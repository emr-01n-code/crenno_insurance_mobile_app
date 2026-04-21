import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/error/error_mapper.dart';
import '../../core/error/failure.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final failure =
        error is Failure ? error as Failure : mapError(error, stackTrace);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: theme.colorScheme.error,
              size: 56,
            ),
            AppSpacing.gapLg,
            Text(
              tr('errors.title'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              tr(failure.messageKey),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.gapLg,
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(tr('common.retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
