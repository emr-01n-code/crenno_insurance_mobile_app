import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable implements Exception {
  const Failure({this.cause, this.stackTrace});

  final Object? cause;
  final StackTrace? stackTrace;

  String get messageKey;

  @override
  List<Object?> get props => [runtimeType, messageKey];

  @override
  String toString() => '$runtimeType($messageKey)';
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.cause, super.stackTrace});

  @override
  String get messageKey => 'errors.network';
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.cause, super.stackTrace});

  @override
  String get messageKey => 'errors.timeout';
}

class ServerFailure extends Failure {
  const ServerFailure({
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;

  @override
  String get messageKey => 'errors.server';

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.cause, super.stackTrace});

  @override
  String get messageKey => 'errors.not_found';
}

class ParsingFailure extends Failure {
  const ParsingFailure({super.cause, super.stackTrace});

  @override
  String get messageKey => 'errors.parsing';
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.messageKey, {super.cause, super.stackTrace});

  @override
  final String messageKey;
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.cause, super.stackTrace});

  @override
  String get messageKey => 'errors.unknown';
}
