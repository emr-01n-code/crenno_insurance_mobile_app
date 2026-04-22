import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import 'policies_providers.dart';

class PoliciesListController extends AsyncNotifier<List<Policy>> {
  @override
  Future<List<Policy>> build() async {
    final useCase = ref.watch(getPoliciesUseCaseProvider);
    return useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Policy>>();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getPoliciesUseCaseProvider);
      return useCase();
    });
  }
}

// Otomatik retry kapalı; hatayı UI'da gösterip "Tekrar Dene" butonuyla
// kullanıcıya seçim bırakıyoruz.
final policiesListControllerProvider =
    AsyncNotifierProvider<PoliciesListController, List<Policy>>(
  PoliciesListController.new,
  retry: (_, _) => null,
);
