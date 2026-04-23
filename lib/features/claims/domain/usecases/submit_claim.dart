import '../../../../core/error/failure.dart';
import '../../../policies/domain/repositories/policy_repository.dart';
import '../entities/claim_request.dart';
import '../repositories/claim_repository.dart';

class SubmitClaim {
  const SubmitClaim({
    required ClaimRepository claimRepository,
    required PolicyRepository policyRepository,
  })  : _claimRepository = claimRepository,
        _policyRepository = policyRepository;

  final ClaimRepository _claimRepository;
  final PolicyRepository _policyRepository;

  Future<String> call(ClaimRequest request) async {
    final policy = await _policyRepository.getPolicyById(request.policyId);

    final incident = _dateOnly(request.incidentDate);
    final start = _dateOnly(policy.startDate);
    final end = _dateOnly(policy.endDate);

    if (incident.isBefore(start) || incident.isAfter(end)) {
      throw const ValidationFailure('claim.date_outside_coverage');
    }

    return _claimRepository.submitClaim(request);
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
