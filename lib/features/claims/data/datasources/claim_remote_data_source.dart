import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/claim_request_dto.dart';

abstract interface class ClaimRemoteDataSource {
  Future<String> submit(ClaimRequestDto payload);
}

class ClaimRemoteDataSourceImpl implements ClaimRemoteDataSource {
  ClaimRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<String> submit(ClaimRequestDto payload) async {
    final response = await _dio.post<Object?>(
      ApiEndpoints.claims,
      data: payload.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['id'] is String) {
      return data['id'] as String;
    }
    throw const FormatException('Claim response missing id field');
  }
}
