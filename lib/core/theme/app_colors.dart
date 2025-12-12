import 'package:flutter/material.dart';

/// App color palette following the design specifications
/// Source of truth for all colors used in the World Cup Prediction App
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Background Colors
  /// Deep Navy - Main background color
  static const Color background = Color(0xFF181928);
  
  /// Soft Dark Blue - Card surface color
  static const Color cardSurface = Color(0xFF222232);

  // Gradient Colors
  /// Primary gradient start color - Blue
  static const Color gradientBlue = Color(0xFF4568DC);
  
  /// Primary gradient end color - Purple
  static const Color gradientPurple = Color(0xFFB06AB3);

  // Text Colors
  /// Primary text color - White
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// Secondary text color - Lavender (for links and secondary text)
  static const Color textSecondary = Color(0xFFD2B5FF);

  // Gradient Definition
  /// Primary linear gradient used across the app
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientBlue, gradientPurple],
  );

  // Border Radius
  /// Main cards border radius
  static const double cardRadius = 15.0;
  
  /// Screen corners border radius
  static const double screenRadius = 28.0;

  // Shadows
  /// Standard card shadow
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.65),
          blurRadius: 34,
          offset: const Offset(10, 5),
        ),
      ];
}
