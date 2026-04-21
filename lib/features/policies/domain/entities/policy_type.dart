import 'package:flutter/material.dart';

enum PolicyType {
  vehicle,
  health,
  home,
  other;

  String get displayKey => switch (this) {
        PolicyType.vehicle => 'policy_types.vehicle',
        PolicyType.health => 'policy_types.health',
        PolicyType.home => 'policy_types.home',
        PolicyType.other => 'policy_types.other',
      };

  IconData get icon => switch (this) {
        PolicyType.vehicle => Icons.directions_car_rounded,
        PolicyType.health => Icons.favorite_rounded,
        PolicyType.home => Icons.home_rounded,
        PolicyType.other => Icons.shield_rounded,
      };

  static PolicyType fromWire(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'vehicle':
      case 'auto':
      case 'car':
        return PolicyType.vehicle;
      case 'health':
      case 'medical':
        return PolicyType.health;
      case 'home':
      case 'house':
        return PolicyType.home;
      default:
        return PolicyType.other;
    }
  }
}
