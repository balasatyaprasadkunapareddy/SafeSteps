import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> rules;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.rules,
  });
}
