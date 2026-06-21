import 'package:flutter/material.dart';

class AppColors {
  // Brand palette: deep emerald with warm gold accents.
  static const Color primary = Color(0xFF0D6E6E);
  static const Color primaryLight = Color(0xFF1A9090);
  static const Color primaryDark = Color(0xFF094F4F);
  static const Color accent = Color(0xFFF5A623);
  static const Color accentLight = Color(0xFFFFBD4A);

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;
  static const Color shimmerBase = Color(0xFFE8EAED);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  static const Color divider = Color(0xFFE5E7EB);
  static const Color inputFill = Color(0xFFF3F4F6);
  static const Color starColor = Color(0xFFFBBC05);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);

  static const Color catSightseeing = Color(0xFF6366F1);
  static const Color catNature = Color(0xFF10B981);
  static const Color catFood = Color(0xFFF97316);
  static const Color catHistory = Color(0xFF8B5CF6);
  static const Color catShopping = Color(0xFFEC4899);
  static const Color catAdventure = Color(0xFFEF4444);
  static const Color catCulture = Color(0xFF0EA5E9);
  static const Color catArchitecture = Color(0xFF64748B);

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sightseeing':
        return catSightseeing;
      case 'nature':
        return catNature;
      case 'food':
        return catFood;
      case 'history':
        return catHistory;
      case 'shopping':
        return catShopping;
      case 'adventure':
        return catAdventure;
      case 'culture':
        return catCulture;
      case 'architecture':
        return catArchitecture;
      default:
        return primary;
    }
  }
}
