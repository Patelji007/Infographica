import 'package:flutter/material.dart';
import 'infographic.dart';

class InfographicCategory {
  final String name;
  final String iconName;
  final String colorName;
  final List<Infographic> infographics;

  InfographicCategory({
    required this.name,
    required this.iconName,
    required this.colorName,
    required this.infographics,
  });

  factory InfographicCategory.fromJson(Map<String, dynamic> json) {
    return InfographicCategory(
      name: json['name'] ?? '',
      iconName: json['icon'] ?? 'folder',
      colorName: json['color'] ?? 'blue',
      infographics: (json['infographics'] as List? ?? [])
          .map((i) => Infographic.fromJson(i))
          .toList(),
    );
  }

  IconData get icon {
    switch (iconName) {
      case 'science': return Icons.science;
      case 'biotech': return Icons.biotech;
      case 'eco': return Icons.eco;
      case 'functions': return Icons.functions;
      case 'public': return Icons.public;
      case 'history': return Icons.history;
      case 'settings': return Icons.settings;
      default: return Icons.folder;
    }
  }

  Color get color {
    switch (colorName) {
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      case 'orange': return Colors.orange;
      case 'purple': return Colors.purple;
      case 'teal': return Colors.teal;
      case 'brown': return Colors.brown;
      case 'indigo': return Colors.indigo;
      default: return Colors.blue;
    }
  }
}
