import '../entities/policy.dart';
import '../repositories/policy_repository.dart';

class GetPolicyById {
  const GetPolicyById(this._repository);

  final PolicyRepository _repository;

  Future<Policy> call(String id) => _repository.getPolicyById(id);
}
