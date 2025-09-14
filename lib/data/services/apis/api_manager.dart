import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/models/check_app_version_model.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/isolate/base_api_isolate.dart';

@singleton
class ApiManager {
  static final Dio dio = Dio();
  static const String baseUrl = "https://mp3quran.net";
  static const String quranRadioEndPoint = "/api/v3/radios";

  static const String _checkVersionUrl =
      'https://mok369.github.io/islamy-app-version-checker/app_version.json';

  Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode) {
    return runInIsolate<ApiResult<List<RadioChannel>>, String>((param) async {
      final Dio dio = Dio();
      try {
        final response = await dio.get(baseUrl + quranRadioEndPoint,
            queryParameters: {"language": languageCode});
        QuranRadioModel quranRadioModel =
            QuranRadioModel.fromJson(response.data);
        if ((response.statusCode ?? 0) >= 200 &&
            (response.statusCode ?? 0) < 300) {
          return Success<List<RadioChannel>>(
              data: quranRadioModel.radios ?? []);
        } else {
          return ServerError<List<RadioChannel>>(
              code: -1, message: "Something Went Wrong 🤔");
        }
      } on Exception catch (e) {
        return CodeError<List<RadioChannel>>(exception: e);
      }
    }, languageCode);
  }

  /*
  Future<ApiResult<List<RadioChannel>>> getQuranRadioChannels(
      String languageCode) async {
    final ReceivePort mainReceivePort = ReceivePort();
    var newIsolate = await Isolate.spawn(
        _getQuranRadioChannelsIsolate, mainReceivePort.sendPort);

    late final SendPort isolateSendPort;
    Completer<ApiResult<List<RadioChannel>>> responseCompleter = Completer();
    mainReceivePort.listen(
      (message) {
        if (message is SendPort) {
          isolateSendPort = message;
          isolateSendPort.send(languageCode);
        } else if (message is ApiResult<List<RadioChannel>>) {
          responseCompleter.complete(message);
        }
      },
    );
    var result = await responseCompleter.future.timeout(Duration(seconds: 60),
        onTimeout: () {
          return CodeError(exception: Exception("Something Went Wrong 🤔"));
    });
    mainReceivePort.close();
    newIsolate.kill(priority: Isolate.immediate);
    return result;
  }

  static void _getQuranRadioChannelsIsolate(SendPort mainSendPort) async {
    ReceivePort isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);
    final Dio dio = Dio();
    isolateReceivePort.listen(
      (languageCode) async {
        try {
          final response = await dio.get(baseUrl + quranRadioEndPoint,
              queryParameters: {"language": languageCode});
          QuranRadioModel quranRadioModel =
              QuranRadioModel.fromJson(response.data);
          if ((response.statusCode ?? 0) >= 200 &&
              (response.statusCode ?? 0) < 300) {
            mainSendPort.send(Success<List<RadioChannel>>(
                data: quranRadioModel.radios ?? []));
          } else {
            mainSendPort.send(ServerError<List<RadioChannel>>(
                code: -1, message: "Something Went Wrong 🤔"));
          }
        } on Exception catch (e) {
          mainSendPort.send(CodeError<List<RadioChannel>>(exception: e));
        }
      },
    );
  }

   */

  Future<ApiResult<CheckAppVersionModel>> checkForUpdate() async {
    return runInIsolate<ApiResult<CheckAppVersionModel>, void>((param) async {
      try {
        final response = await dio.get(_checkVersionUrl);
        if (response.statusCode == 200) {
          List keys = (response.data as Map).keys.toList();
          const String store = String.fromEnvironment('STORE');
          CheckAppVersionModel checkAppVersionModel =
              CheckAppVersionModel.fromJson(
                  response.data[store.isNotEmpty ? store : keys.first]);

          return Success(data: checkAppVersionModel);
        } else {
          return ServerError(code: -1, message: "Something Went Wrong 🤔");
        }
      } on Exception catch (e) {
        return CodeError(exception: e);
      }
    }, null);
  }
}
