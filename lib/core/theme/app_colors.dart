import 'package:flutter/material.dart';

/// Application color palette with beautiful gradients and dark theme colors
class AppColors {
  // Primary Colors - Vibrant Purple/Blue Gradient
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5548C8);
  static const Color primaryLight = Color(0xFF8B84FF);
  
  // Accent Colors
  static const Color accent = Color(0xFFFF6584);
  static const Color accentLight = Color(0xFFFF8FA3);
  
  // Background Colors - Dark Theme
  static const Color background = Color(0xFF0F0F1E);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF25253E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB4B4C8);
  static const Color textHint = Color(0xFF6E6E8C);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5548C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF25253E),
      Color(0xFF1A1A2E),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Glassmorphism overlay
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color glassOverlayDark = Color(0x0DFFFFFF);
  
  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFF5F5FA);
  static const Color surfaceLightMode = Color(0xFFFFFFFF);
  static const Color surfaceLightModeElevated = Color(0xFFF0F0F5);
  
  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6E6E8C);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Divider & Border
  static const Color divider = Color(0xFF2A2A3E);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color border = Color(0xFF3A3A4E);
  static const Color borderLight = Color(0xFFEBEBEB);
}
