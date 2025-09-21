sealed class ApiResult<T> {}

class Success<T> extends ApiResult<T> {
  T data;

  Success({required this.data});

  @override
  bool operator ==(Object other) {
    return other is Success && data == other.data;
  }
}

class ServerError<T> extends ApiResult<T> {
  num code;
  String message;

  ServerError({required this.code, required this.message});

  @override
  bool operator ==(Object other) {
    return other is ServerError &&
        code == other.code &&
        message == other.message;
  }
}

class CodeError<T> extends ApiResult<T> {
  Exception exception;

  CodeError({required this.exception});

  @override
  bool operator ==(Object other) {
    return other is CodeError && exception == exception;
  }
}
