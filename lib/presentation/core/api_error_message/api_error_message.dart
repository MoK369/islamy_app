import 'dart:io';

import 'package:dio/dio.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';

class ApiErrorMessage {
  static String getErrorMessage(
      {ServerError? serverError, CodeError? codeError}) {
    AppLocalizations appLocalizations = getIt.get<AppLocalizations>();
    if (serverError != null) {
      return serverError.message;
    } else if (codeError != null) {
      var exception = codeError.exception;
      switch (exception) {
        case SocketException():
          return appLocalizations.noInternetConnection;
        case HttpException():
          return appLocalizations.couldNotFindSource;
        case FormatException():
          return appLocalizations.badResponse;
        case DioException():
          switch (exception.type) {
            case DioExceptionType.connectionTimeout:
              return appLocalizations.connectionTimeout;
            case DioExceptionType.sendTimeout:
              return appLocalizations.sendTimeout;
            case DioExceptionType.receiveTimeout:
              return appLocalizations.receiveTimeout;
            case DioExceptionType.badCertificate:
              return appLocalizations.badCertificate;
            case DioExceptionType.badResponse:
              return appLocalizations.badResponse;
            case DioExceptionType.cancel:
              return appLocalizations.requestCanceled;
            case DioExceptionType.connectionError:
              return appLocalizations.noInternetConnection;
            case DioExceptionType.unknown:
              return appLocalizations.somethingWentWrong;
          }

        default:
          return appLocalizations.somethingWentWrong;
      }
    } else {
      return appLocalizations.somethingWentWrong;
    }
  }
}
