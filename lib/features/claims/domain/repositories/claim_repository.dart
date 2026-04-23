import '../entities/claim_request.dart';

abstract interface class ClaimRepository {
  Future<String> submitClaim(ClaimRequest request);
}
