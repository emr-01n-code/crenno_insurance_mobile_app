import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart' show rootBundle;

class MockInterceptor extends Interceptor {
  MockInterceptor({
    this.minDelay = const Duration(milliseconds: 600),
    this.maxDelay = const Duration(milliseconds: 900),
    this.forceError = false,
    Random? random,
  }) : _random = random ?? Random();

  final Duration minDelay;
  final Duration maxDelay;
  final bool forceError;

  final Random _random;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(_randomDelay());

    if (forceError) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'Forced mock error',
        ),
      );
      return;
    }

    try {
      final response = await _resolve(options);
      handler.resolve(response);
    } on _MockNotFound catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<Object?>(
            requestOptions: options,
            statusCode: 404,
            data: {'message': e.message},
          ),
        ),
      );
    } catch (e, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<Response<Object?>> _resolve(RequestOptions options) async {
    final method = options.method.toUpperCase();
    final path = options.path;

    if (method == 'GET' && path == '/policies') {
      final body = await _loadJson('assets/mock/policies.json');
      return _ok(options, body);
    }

    if (method == 'GET' && path.startsWith('/policies/')) {
      final id = path.substring('/policies/'.length);
      if (id.isEmpty) {
        throw const _MockNotFound('Missing policy id');
      }
      final body = await _loadJson('assets/mock/policy_$id.json');
      return _ok(options, body);
    }

    if (method == 'POST' && path == '/claims') {
      return Response<Object?>(
        requestOptions: options,
        statusCode: 201,
        data: {
          'id': 'claim_${DateTime.now().millisecondsSinceEpoch}',
          'status': 'received',
        },
      );
    }

    throw _MockNotFound('No mock defined for $method $path');
  }

  Response<Object?> _ok(RequestOptions options, Object? body) {
    return Response<Object?>(
      requestOptions: options,
      statusCode: 200,
      data: body,
    );
  }

  Future<Object?> _loadJson(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      return jsonDecode(raw);
    } on FlutterError {
      throw _MockNotFound('Missing asset: $assetPath');
    }
  }

  Duration _randomDelay() {
    final minMs = minDelay.inMilliseconds;
    final maxMs = maxDelay.inMilliseconds;
    if (maxMs <= minMs) return minDelay;
    final span = maxMs - minMs;
    return Duration(milliseconds: minMs + _random.nextInt(span));
  }
}

class _MockNotFound implements Exception {
  const _MockNotFound(this.message);
  final String message;
  @override
  String toString() => 'MockNotFound: $message';
}
