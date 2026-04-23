import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/claim_request.dart';
import '../../domain/repositories/claim_repository.dart';
import '../datasources/claim_remote_data_source.dart';
import '../models/claim_request_dto.dart';

class ClaimRepositoryImpl implements ClaimRepository {
  const ClaimRepositoryImpl(this._remote);

  final ClaimRemoteDataSource _remote;

  @override
  Future<String> submitClaim(ClaimRequest request) async {
    try {
      return await _remote.submit(ClaimRequestDto.fromDomain(request));
    } catch (e, stackTrace) {
      throw mapError(e, stackTrace);
    }
  }
}
