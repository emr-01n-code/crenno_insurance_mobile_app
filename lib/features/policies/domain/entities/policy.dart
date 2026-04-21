import 'package:equatable/equatable.dart';

import 'policy_type.dart';

class Policy extends Equatable {
  const Policy({
    required this.id,
    required this.policyNumber,
    required this.holderName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.coverageAmount,
    required this.currency,
  });

  final String id;
  final String policyNumber;
  final String holderName;
  final PolicyType type;
  final DateTime startDate;
  final DateTime endDate;
  final num coverageAmount;
  final String currency;

  bool get isActive {
    final now = DateTime.now();
    return !now.isBefore(startDate) && !now.isAfter(endDate);
  }

  Duration get remaining => endDate.difference(DateTime.now());

  @override
  List<Object?> get props => [
        id,
        policyNumber,
        holderName,
        type,
        startDate,
        endDate,
        coverageAmount,
        currency,
      ];
}
