import 'package:flutter/material.dart';

/// App color palette following the design specifications
/// Source of truth for all colors used in the World Cup Prediction App
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Background Colors
  /// Pure Black - Main background color
  static const Color background = Color(0xFF000000);
  
  /// Very Dark Grey - Card surface color
  static const Color cardSurface = Color(0xFF121212);

  // Primary Color
  /// Neon Green - Primary accent color
  static const Color primary = Color(0xFF0df259);
  
  /// Primary gradient start color - Neon Green
  static const Color gradientGreen = Color(0xFF0df259);
  
  /// Primary gradient end color - Lighter Green
  static const Color gradientLightGreen = Color(0xFF00ff7f);

  // Text Colors
  /// Primary text color - White
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// Secondary text color - Grey
  static const Color textSecondary = Color(0xFF9ca3af);
  
  /// Tertiary text color - Darker Grey (for subtle text)
  static const Color textTertiary = Color(0xFF6b7280);

  // Gradient Definition
  /// Primary linear gradient used across the app (Neon Green)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientGreen, gradientLightGreen],
  );

  // Backwards-compatible aliases (added to fix references across widgets)
  /// Card background alias (previous code used `cardBackground` in places)
  static const Color cardBackground = cardSurface;

  /// A blue accent color used by some widgets as `gradientBlue`
  static const Color gradientBlue = Color(0xFF2196F3);

  // Border Radius
  /// Main cards border radius
  static const double cardRadius = 16.0;
  
  /// Screen corners border radius
  static const double screenRadius = 20.0;
  
  /// Small elements border radius
  static const double smallRadius = 12.0;

  // Shadows
  /// Standard card shadow
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
  
  /// Neon glow effect for primary elements
  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
