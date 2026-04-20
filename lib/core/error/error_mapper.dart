import 'package:dio/dio.dart';

import 'failure.dart';

Failure mapError(Object error, [StackTrace? stackTrace]) {
  if (error is Failure) return error;

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(cause: error, stackTrace: stackTrace);
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkFailure(cause: error, stackTrace: stackTrace);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return UnknownFailure(cause: error, stackTrace: stackTrace);
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 404) {
          return NotFoundFailure(cause: error, stackTrace: stackTrace);
        }
        return ServerFailure(
          statusCode: status,
          cause: error,
          stackTrace: stackTrace,
        );
    }
  }

  if (error is FormatException || error is TypeError) {
    return ParsingFailure(cause: error, stackTrace: stackTrace);
  }

  return UnknownFailure(cause: error, stackTrace: stackTrace);
}
