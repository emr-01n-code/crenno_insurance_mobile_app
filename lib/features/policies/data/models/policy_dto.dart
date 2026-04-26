import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_type.dart';

class PolicyDto {
  PolicyDto({
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
  final String type;
  final String startDate;
  final String endDate;
  final num coverageAmount;
  final String currency;

  factory PolicyDto.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      if (id is! String || id.isEmpty) {
        throw FormatException('Missing or invalid "id" (string expected)', json);
      }

      final policyNumber = json['policyNumber'];
      if (policyNumber is! String || policyNumber.isEmpty) {
        throw FormatException(
          'Missing or invalid "policyNumber" (string expected)',
          json,
        );
      }

      final startDate = json['startDate'];
      if (startDate is! String || startDate.isEmpty) {
        throw FormatException(
          'Missing or invalid "startDate" (string expected)',
          json,
        );
      }

      final endDate = json['endDate'];
      if (endDate is! String || endDate.isEmpty) {
        throw FormatException(
          'Missing or invalid "endDate" (string expected)',
          json,
        );
      }

      // backend sometimes sends string instead of num
      final coverageRaw = json['coverageAmount'];
      final num coverageAmount;
      if (coverageRaw is num) {
        coverageAmount = coverageRaw;
      } else if (coverageRaw is String) {
        final parsed = num.tryParse(coverageRaw);
        if (parsed == null) {
          throw FormatException(
            'Missing or invalid "coverageAmount" (number expected)',
            json,
          );
        }
        coverageAmount = parsed;
      } else {
        throw FormatException(
          'Missing or invalid "coverageAmount" (number expected)',
          json,
        );
      }

      final holderRaw = json['holderName'];
      final holderName = holderRaw is String && holderRaw.isNotEmpty
          ? holderRaw
          : '—';

      final typeRaw = json['type'];
      final type = typeRaw is String && typeRaw.isNotEmpty ? typeRaw : 'other';

      final currencyRaw = json['currency'];
      final currency = currencyRaw is String && currencyRaw.isNotEmpty
          ? currencyRaw
          : 'TRY';

      return PolicyDto(
        id: id,
        policyNumber: policyNumber,
        holderName: holderName,
        type: type,
        startDate: startDate,
        endDate: endDate,
        coverageAmount: coverageAmount,
        currency: currency,
      );
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Invalid Policy payload: $e', json);
    }
  }

  Policy toDomain() {
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    if (start == null || end == null) {
      throw FormatException(
        'Invalid policy dates: start=$startDate end=$endDate',
      );
    }
    return Policy(
      id: id,
      policyNumber: policyNumber,
      holderName: holderName,
      type: PolicyType.fromWire(type),
      startDate: start,
      endDate: end,
      coverageAmount: coverageAmount,
      currency: currency,
    );
  }
}
