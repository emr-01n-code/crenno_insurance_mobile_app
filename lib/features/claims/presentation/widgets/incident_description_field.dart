import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IncidentDescriptionField extends StatelessWidget {
  const IncidentDescriptionField({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: 5,
      minLines: 4,
      maxLength: 500,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        labelText: tr('claim.description_label'),
        hintText: tr('claim.description_hint'),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return tr('claim.description_required');
        if (text.length < 10) {
          return tr('claim.description_too_short');
        }
        return null;
      },
    );
  }
}
