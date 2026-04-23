import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_providers.dart';
import '../../../policies/presentation/providers/policies_providers.dart';
import '../../data/datasources/claim_remote_data_source.dart';
import '../../data/repositories/claim_repository_impl.dart';
import '../../domain/repositories/claim_repository.dart';
import '../../domain/usecases/submit_claim.dart';

final claimRemoteDataSourceProvider = Provider<ClaimRemoteDataSource>((ref) {
  return ClaimRemoteDataSourceImpl(ref.watch(dioProvider));
});

final claimRepositoryProvider = Provider<ClaimRepository>((ref) {
  return ClaimRepositoryImpl(ref.watch(claimRemoteDataSourceProvider));
});

final submitClaimUseCaseProvider = Provider<SubmitClaim>((ref) {
  return SubmitClaim(
    claimRepository: ref.watch(claimRepositoryProvider),
    policyRepository: ref.watch(policyRepositoryProvider),
  );
});
