import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final String sceneLabel;
  final List<IconData> floatingIcons;
  final List<String> highlights;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.sceneLabel,
    required this.floatingIcons,
    required this.highlights,
  });
}
