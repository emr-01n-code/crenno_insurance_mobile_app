import '../entities/policy.dart';

abstract interface class PolicyRepository {
  Future<List<Policy>> getPolicies();

  Future<Policy> getPolicyById(String id);
}
