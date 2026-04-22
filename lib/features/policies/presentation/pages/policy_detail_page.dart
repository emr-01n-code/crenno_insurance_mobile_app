import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_view.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/policy.dart';
import '../providers/policy_detail_provider.dart';
import '../widgets/policy_info_row.dart';
import '../widgets/policy_type_badge.dart';

class PolicyDetailPage extends ConsumerWidget {
  const PolicyDetailPage({super.key, required this.policyId});

  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(policyDetailProvider(policyId));

    return Scaffold(
      appBar: AppBar(title: Text(tr('policy_detail.title'))),
      body: SafeArea(
        child: detailAsync.when(
          loading: () => AppLoadingView(message: tr('policy_detail.loading')),
          error: (error, stack) => AppErrorView(
            error: error,
            stackTrace: stack,
            onRetry: () => ref.invalidate(policyDetailProvider(policyId)),
          ),
          data: (policy) => _DetailBody(policy: policy),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = context.locale.toLanguageTag();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          children: [
            PolicyTypeBadge(type: policy.type, size: 56),
            AppSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(policy.type.displayKey),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    policy.policyNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.gapXl,
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                PolicyInfoRow(
                  icon: Icons.person_rounded,
                  label: tr('policy_detail.holder'),
                  value: policy.holderName,
                ),
                const Divider(height: 1),
                PolicyInfoRow(
                  icon: Icons.calendar_month_rounded,
                  label: tr('policy_detail.start_date'),
                  value: DateFormatter.display(policy.startDate, locale),
                ),
                const Divider(height: 1),
                PolicyInfoRow(
                  icon: Icons.event_busy_rounded,
                  label: tr('policy_detail.end_date'),
                  value: DateFormatter.display(policy.endDate, locale),
                ),
                const Divider(height: 1),
                PolicyInfoRow(
                  icon: Icons.shield_rounded,
                  label: tr('policy_detail.coverage'),
                  value: CurrencyFormatter.format(
                    policy.coverageAmount,
                    policy.currency,
                    locale,
                  ),
                ),
                const Divider(height: 1),
                PolicyInfoRow(
                  icon: policy.isActive
                      ? Icons.check_circle_rounded
                      : Icons.remove_circle_rounded,
                  label: tr('policy_detail.status'),
                  value: policy.isActive
                      ? tr('policy_detail.status_active')
                      : tr('policy_detail.status_expired'),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapXl,
        PrimaryButton(
          label: tr('policy_detail.file_claim'),
          icon: Icons.report_rounded,
          onPressed: () => context.pushNamed(
            AppRoutes.claimSubmissionName,
            pathParameters: {'id': policy.id},
          ),
        ),
      ],
    );
  }
}
