import 'package:flutter/material.dart';
import 'team_logo_manager.dart';

/// DEPRECATED: Use LocalTeamLogoWidget from team_logo_manager.dart instead
/// 
/// This file kept for backwards compatibility
/// Will be removed in future versions

/// Cached version of TeamLogoWidget that loads from local assets
/// 
/// Uses local PNG files named with team IDs (e.g., 2829.png for Barcelona)
class CachedTeamLogoWidget extends StatelessWidget {
  final int teamId;
  final double size;
  final BoxFit fit;
  final Color? fallbackIconColor;

  const CachedTeamLogoWidget({
    super.key,
    required this.teamId,
    this.size = 40,
    this.fit = BoxFit.contain,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    // Delegate to LocalTeamLogoWidget
    return LocalTeamLogoWidget(
      teamId: teamId,
      size: size,
      fit: fit,
      fallbackIconColor: fallbackIconColor,
    );
  }
}
