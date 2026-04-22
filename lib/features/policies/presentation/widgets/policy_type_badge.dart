import 'package:flutter/material.dart';

import '../../domain/entities/policy_type.dart';

class PolicyTypeBadge extends StatelessWidget {
  const PolicyTypeBadge({
    super.key,
    required this.type,
    this.size = 44,
  });

  final PolicyType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(size / 3),
      ),
      alignment: Alignment.center,
      child: Icon(
        type.icon,
        color: scheme.onPrimaryContainer,
        size: size * 0.55,
      ),
    );
  }
}
