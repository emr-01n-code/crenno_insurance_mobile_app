import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';

class IncidentDateField extends StatelessWidget {
  const IncidentDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;

  Future<void> _pickDate(
    BuildContext context,
    FormFieldState<DateTime> state,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: tr('claim.date_picker_help'),
      cancelText: tr('common.cancel'),
      confirmText: tr('common.ok'),
    );
    if (picked != null) {
      state.didChange(picked);
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.toLanguageTag();

    return FormField<DateTime>(
      initialValue: value,
      validator: (date) {
        if (date == null) return tr('claim.date_required');
        if (date.isAfter(DateTime.now())) return tr('claim.date_in_future');
        return null;
      },
      builder: (state) {
        final selected = state.value;
        return InkWell(
          onTap: enabled ? () => _pickDate(context, state) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: tr('claim.date_label'),
              prefixIcon: const Icon(Icons.calendar_today_rounded),
              hintText: tr('claim.date_hint'),
              errorText: state.errorText,
              enabled: enabled,
            ),
            isEmpty: selected == null,
            child: Text(
              selected != null ? DateFormatter.display(selected, locale) : '',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}
