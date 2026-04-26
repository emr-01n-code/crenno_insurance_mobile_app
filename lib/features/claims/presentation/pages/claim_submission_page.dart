import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../policies/presentation/providers/policies_list_controller.dart';
import '../../../policies/presentation/providers/policy_detail_provider.dart';
import '../../domain/entities/claim_request.dart';
import '../providers/claim_submission_controller.dart';
import '../widgets/incident_date_field.dart';
import '../widgets/incident_description_field.dart';

class ClaimSubmissionPage extends ConsumerStatefulWidget {
  const ClaimSubmissionPage({super.key, required this.policyId});

  final String policyId;

  @override
  ConsumerState<ClaimSubmissionPage> createState() =>
      _ClaimSubmissionPageState();
}

class _ClaimSubmissionPageState extends ConsumerState<ClaimSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  DateTime? _incidentDate;
  bool _submitted = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _incidentDate == null) return;

    FocusScope.of(context).unfocus();

    final request = ClaimRequest(
      policyId: widget.policyId,
      incidentDate: _incidentDate!,
      description: _descriptionController.text.trim(),
    );

    await ref
        .read(claimSubmissionControllerProvider.notifier)
        .submit(request);

    if (!mounted) return;
    final state = ref.read(claimSubmissionControllerProvider);
    state.when(
      loading: () {},
      error: (error, _) {
        final failure = error is Failure ? error : mapError(error);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(tr(failure.messageKey)),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
      },
      data: (_) {
        ref.invalidate(policiesListControllerProvider);
        ref.invalidate(policyDetailProvider(widget.policyId));

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(tr('claim.success_message'))),
          );
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(claimSubmissionControllerProvider);
    final isSubmitting = asyncState.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr('claim.title'))),
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: isSubmitting,
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  tr('claim.intro_title'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  tr('claim.intro_text'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapXl,
                IncidentDateField(
                  value: _incidentDate,
                  enabled: !isSubmitting,
                  onChanged: (date) => setState(() => _incidentDate = date),
                ),
                AppSpacing.gapLg,
                IncidentDescriptionField(
                  controller: _descriptionController,
                  enabled: !isSubmitting,
                ),
                AppSpacing.gapXl,
                PrimaryButton(
                  label: tr('claim.submit'),
                  icon: Icons.send_rounded,
                  isLoading: isSubmitting,
                  onPressed: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
