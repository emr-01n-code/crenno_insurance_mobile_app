import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../providers/policies_list_controller.dart';
import '../widgets/policy_card.dart';

class PolicyListPage extends ConsumerWidget {
  const PolicyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policiesListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('policies.title')),
        actions: [
          IconButton(
            tooltip: tr('policies.refresh_tooltip'),
            onPressed: () =>
                ref.read(policiesListControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: state.when(
          loading: () => AppLoadingView(message: tr('policies.loading')),
          error: (error, stack) => AppErrorView(
            error: error,
            stackTrace: stack,
            onRetry: () => ref.invalidate(policiesListControllerProvider),
          ),
          data: (policies) {
            if (policies.isEmpty) {
              return AppEmptyView(
                title: tr('policies.empty_title'),
                message: tr('policies.empty_message'),
                icon: Icons.shield_outlined,
              );
            }
            return RefreshIndicator.adaptive(
              onRefresh: () =>
                  ref.read(policiesListControllerProvider.notifier).refresh(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
                ),
                itemCount: policies.length,
                separatorBuilder: (_, _) => AppSpacing.gapMd,
                itemBuilder: (context, index) {
                  final policy = policies[index];
                  return PolicyCard(
                    policy: policy,
                    onTap: () => context.pushNamed(
                      AppRoutes.policyDetailName,
                      pathParameters: {'id': policy.id},
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
