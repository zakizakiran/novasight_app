import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
  final String title;
  final String semanticLabel;

  const BottomNavItem({
    required this.icon,
    required this.title,
    required this.semanticLabel,
  });
}

