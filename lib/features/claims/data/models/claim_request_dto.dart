import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/claim_request.dart';

class ClaimRequestDto {
  ClaimRequestDto({
    required this.policyId,
    required this.incidentDate,
    required this.description,
  });

  final String policyId;
  final String incidentDate;
  final String description;

  factory ClaimRequestDto.fromDomain(ClaimRequest request) {
    return ClaimRequestDto(
      policyId: request.policyId,
      incidentDate: DateFormatter.iso(request.incidentDate),
      description: request.description,
    );
  }

  Map<String, dynamic> toJson() => {
        'policyId': policyId,
        'incidentDate': incidentDate,
        'description': description,
      };
}
