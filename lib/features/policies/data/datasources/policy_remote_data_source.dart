import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/policy_dto.dart';

abstract interface class PolicyRemoteDataSource {
  Future<List<PolicyDto>> fetchPolicies();
  Future<PolicyDto> fetchPolicyById(String id);
}

class PolicyRemoteDataSourceImpl implements PolicyRemoteDataSource {
  PolicyRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PolicyDto>> fetchPolicies() async {
    final response = await _dio.get<Object?>(ApiEndpoints.policies);
    final raw = response.data;
    if (raw is! List) {
      throw const FormatException('Expected a JSON list for /policies');
    }
    return raw
        .cast<Map<String, dynamic>>()
        .map(PolicyDto.fromJson)
        .toList(growable: false);
  }

  @override
  Future<PolicyDto> fetchPolicyById(String id) async {
    final response = await _dio.get<Object?>(ApiEndpoints.policyById(id));
    final raw = response.data;
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object for /policies/{id}');
    }
    return PolicyDto.fromJson(raw);
  }
}
