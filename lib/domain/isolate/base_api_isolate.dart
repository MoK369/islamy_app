import 'dart:async';
import 'dart:isolate';

Future<T> runInIsolate<T, P>(
  FutureOr<T> Function(P param) isolateFunction,
  P param,
) async {
  final mainReceivePort = ReceivePort();
  final completer = Completer<T>();

  var newIsolate = await Isolate.spawn<_IsolateMessage<T, P>>(
    _isolateEntryPoint,
    _IsolateMessage(
      sendPort: mainReceivePort.sendPort,
      function: isolateFunction,
      param: param,
    ),
  );

  mainReceivePort.listen((message) {
    if (message is T) {
      completer.complete(message);
      mainReceivePort.close();
    }
  });

  var result = await completer.future;
  newIsolate.kill(priority: Isolate.immediate);
  return result;
}

class _IsolateMessage<T, P> {
  final SendPort sendPort;
  final FutureOr<T> Function(P param) function;
  final P param;

  _IsolateMessage({
    required this.sendPort,
    required this.function,
    required this.param,
  });
}

void _isolateEntryPoint<T, P>(_IsolateMessage<T, P> message) async {
  final result = await message.function(message.param);
  message.sendPort.send(result);
}
