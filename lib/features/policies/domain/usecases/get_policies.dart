import '../entities/policy.dart';
import '../repositories/policy_repository.dart';

class GetPolicies {
  const GetPolicies(this._repository);

  final PolicyRepository _repository;

  Future<List<Policy>> call() async {
    final all = await _repository.getPolicies();
    final active = all.where((p) => p.isActive).toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    return List.unmodifiable(active);
  }
}
