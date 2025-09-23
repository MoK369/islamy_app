import 'dart:async';

import 'package:islamy_app/presentation/core/utils/toasts/toasts.dart';

FutureOr<T?>? executeHandler<T>(FutureOr<T> Function() fnToExecute,
    {String? errorMessage}) async {
  try {
    return await fnToExecute();
  } catch (e) {
    Toasts.showErrorToast(errorMessage ?? e.toString());
  }
  return null;
}
