import 'package:islamy_app/domain/api_result/api_result.dart';

sealed class BaseViewState<T> {}

class LoadingState<T> extends BaseViewState<T> {
  String? message;

  LoadingState({this.message});
}

class SuccessState<T> extends BaseViewState<T> {
  T data;

  SuccessState({required this.data});
}

class ErrorState<T> extends BaseViewState<T> {
  ServerError? serverError;
  CodeError? codeError;

  ErrorState({this.serverError, this.codeError});
}
