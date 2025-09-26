import 'package:islamy_app/domain/api_result/api_result.dart';

sealed class BaseViewState<T> {}

class IdleState<T> extends BaseViewState<T> {}

class LoadingState<T> extends BaseViewState<T> {
  String? message;

  LoadingState({this.message});

  @override
  bool operator ==(Object other) {
    return other is LoadingState<T> && message == other.message;
  }
}

class SuccessState<T> extends BaseViewState<T> {
  T data;

  SuccessState({required this.data});

  @override
  bool operator ==(Object other) {
    return other is SuccessState<T> && data == other.data;
  }
}

class ErrorState<T> extends BaseViewState<T> {
  ServerError? serverError;
  CodeError? codeError;

  ErrorState({this.serverError, this.codeError});

  @override
  bool operator ==(Object other) {
    return other is ErrorState<T> &&
        serverError == other.serverError &&
        codeError == other.codeError;
  }
}
