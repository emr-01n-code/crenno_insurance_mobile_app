import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import 'policies_providers.dart';

final policyDetailProvider =
    FutureProvider.autoDispose.family<Policy, String>(
  (ref, id) async {
    final useCase = ref.watch(getPolicyByIdUseCaseProvider);
    return useCase(id);
  },
  retry: (_, _) => null,
);
