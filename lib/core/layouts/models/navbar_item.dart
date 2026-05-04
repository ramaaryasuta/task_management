import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData iconSelected;
  final int? badgeCount;
  final String? badgeTooltip;

  const NavItem({
    required this.label,
    required this.icon,
    required this.iconSelected,
    this.badgeCount,
    this.badgeTooltip,
  });
}
