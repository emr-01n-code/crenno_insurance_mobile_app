import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_providers.dart';
import '../../data/datasources/policy_remote_data_source.dart';
import '../../data/repositories/policy_repository_impl.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../domain/usecases/get_policies.dart';
import '../../domain/usecases/get_policy_by_id.dart';

final policyRemoteDataSourceProvider = Provider<PolicyRemoteDataSource>((ref) {
  return PolicyRemoteDataSourceImpl(ref.watch(dioProvider));
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  return PolicyRepositoryImpl(ref.watch(policyRemoteDataSourceProvider));
});

final getPoliciesUseCaseProvider = Provider<GetPolicies>((ref) {
  return GetPolicies(ref.watch(policyRepositoryProvider));
});

final getPolicyByIdUseCaseProvider = Provider<GetPolicyById>((ref) {
  return GetPolicyById(ref.watch(policyRepositoryProvider));
});
