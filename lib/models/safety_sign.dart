import 'package:flutter/material.dart';

enum SignCategory {
  mandatory,
  cautionary,
  informatory;

  String get label {
    switch (this) {
      case SignCategory.mandatory:
        return 'Mandatory';
      case SignCategory.cautionary:
        return 'Cautionary';
      case SignCategory.informatory:
        return 'Informatory';
    }
  }

  Color get color {
    switch (this) {
      case SignCategory.mandatory:
        return const Color(0xFFEF4444); // red
      case SignCategory.cautionary:
        return const Color(0xFFF59E0B); // amber
      case SignCategory.informatory:
        return const Color(0xFF2563EB); // blue
    }
  }

  Color get bgColor {
    switch (this) {
      case SignCategory.mandatory:
        return const Color(0xFFFEF2F2);
      case SignCategory.cautionary:
        return const Color(0xFFFFFBEB);
      case SignCategory.informatory:
        return const Color(0xFFEFF6FF);
    }
  }

  IconData get filterIcon {
    switch (this) {
      case SignCategory.mandatory:
        return Icons.block;
      case SignCategory.cautionary:
        return Icons.warning_amber_rounded;
      case SignCategory.informatory:
        return Icons.info_outline;
    }
  }
}

class SafetySign {
  final String id;
  final String name;
  final String description;
  final String detail;
  final SignCategory category;
  final IconData icon;

  const SafetySign({
    required this.id,
    required this.name,
    required this.description,
    required this.detail,
    required this.category,
    required this.icon,
  });

  Color get color => category.color;
  Color get bgColor => category.bgColor;
}
