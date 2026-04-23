import 'package:equatable/equatable.dart';

class ClaimRequest extends Equatable {
  const ClaimRequest({
    required this.policyId,
    required this.incidentDate,
    required this.description,
  });

  final String policyId;
  final DateTime incidentDate;
  final String description;

  @override
  List<Object?> get props => [policyId, incidentDate, description];
}
