import 'dart:async';

import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/utils/toasts/toasts.dart';

FutureOr<T?>? executeHandler<T>(FutureOr<T> Function() fnToExecute,
    {String? errorMessage,
    FutureOr<void> Function(Object error)? onErrorExecute}) async {
  try {
    return await fnToExecute();
  } catch (e) {
    if (onErrorExecute != null) await onErrorExecute(e);
    getIt.get<CustomToasts>().showErrorToast(errorMessage ?? e.toString());
  }
  return null;
}
