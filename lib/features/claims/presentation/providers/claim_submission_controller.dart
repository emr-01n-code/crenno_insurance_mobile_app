import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/claim_request.dart';
import 'claim_providers.dart';

class ClaimSubmissionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> submit(ClaimRequest request) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      final useCase = ref.read(submitClaimUseCaseProvider);
      await useCase(request);
    });
  }
}

final claimSubmissionControllerProvider =
    AsyncNotifierProvider.autoDispose<ClaimSubmissionController, void>(
  ClaimSubmissionController.new,
  retry: (_, _) => null,
);
