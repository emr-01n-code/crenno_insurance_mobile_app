import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../datasources/policy_remote_data_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  const PolicyRepositoryImpl(this._remote);

  final PolicyRemoteDataSource _remote;

  @override
  Future<List<Policy>> getPolicies() async {
    try {
      final dtos = await _remote.fetchPolicies();
      return dtos.map((dto) => dto.toDomain()).toList(growable: false);
    } catch (e, stackTrace) {
      throw mapError(e, stackTrace);
    }
  }

  @override
  Future<Policy> getPolicyById(String id) async {
    try {
      final dto = await _remote.fetchPolicyById(id);
      return dto.toDomain();
    } catch (e, stackTrace) {
      throw mapError(e, stackTrace);
    }
  }
}
