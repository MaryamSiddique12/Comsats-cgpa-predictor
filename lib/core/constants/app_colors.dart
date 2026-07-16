import 'package:flutter/material.dart';

/// Centralized color palette for the whole app.
///
/// Keeping every color in one place means the "blue accent / dark blue
/// gradient header / white cards" look required by the brief can be
/// re-themed later (e.g. per-university branding) by editing only this
/// file.
class AppColors {
  AppColors._();

  // Primary brand blues (used for the header gradient and accents).
  static const Color primaryDark = Color(0xFF0B2545);
  static const Color primary = Color(0xFF13315C);
  static const Color primaryLight = Color(0xFF1D4E89);
  static const Color accent = Color(0xFF2E7CF6);

  // Header gradient (dark blue -> slightly lighter blue).
  static const List<Color> headerGradient = [
    primaryDark,
    primary,
    primaryLight,
  ];

  // Neutral surface colors.
  static const Color background = Color(0xFFF4F6FA);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE3E8F0);

  // Text colors.
  static const Color textPrimary = Color(0xFF1A2233);
  static const Color textSecondary = Color(0xFF5B6472);
  static const Color textOnPrimary = Colors.white;

  // Semantic / feedback colors.
  static const Color success = Color(0xFF1F9D55);
  static const Color warning = Color(0xFFE0A100);
  static const Color error = Color(0xFFD64545);

  // Result-card accent colors (kept in the same blue family so the
  // dashboard reads as one cohesive palette rather than a rainbow).
  static const Color cardAccentBlue = accent;
  static const Color cardAccentTeal = Color(0xFF12897B);
  static const Color cardAccentIndigo = Color(0xFF5C4EE5);
  static const Color cardAccentNavy = primary;
}
