import 'package:flutter/material.dart';

/// Local Asset-based Team Logo Manager
/// 
/// Uses team IDs from SofaScore to load logos from local assets
/// Format: assets/images/team_logos/{teamId}.png
class TeamLogoManager {
  /// Get asset path for a team logo by team ID
  static String getLogoPath(int teamId) {
    return 'assets/images/team_logos/$teamId.png';
  }

  /// Check if a team logo exists in assets
  /// This is a helper - Flutter will handle missing assets gracefully
  static bool hasLogo(int teamId) {
    // Common team IDs that we have logos for
    // This list will grow as we add more logos
    final availableLogos = <int>{
      // Premier League
      17, // Manchester City
      18, // Manchester United
      19, // Chelsea
      20, // Liverpool
      21, // Arsenal
      22, // Tottenham
      
      // La Liga
      2829, // Barcelona
      2817, // Real Madrid
      2833, // Atletico Madrid
      
      // Bundesliga
      2672, // Bayern Munich
      2673, // Borussia Dortmund
      
      // Serie A
      2697, // Juventus
      2692, // Inter Milan
      2687, // AC Milan
      
      // Ligue 1
      1644, // PSG
      
      // Add more as needed...
    };
    
    return availableLogos.contains(teamId);
  }
}

/// Widget to display team logos from local assets
/// Falls back to icon if logo not found
class LocalTeamLogoWidget extends StatelessWidget {
  final int teamId;
  final double size;
  final BoxFit fit;
  final Color? fallbackIconColor;

  const LocalTeamLogoWidget({
    super.key,
    required this.teamId,
    this.size = 40,
    this.fit = BoxFit.contain,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final logoPath = TeamLogoManager.getLogoPath(teamId);

    return Image.asset(
      logoPath,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if logo not found
        return Icon(
          Icons.shield_outlined,
          size: size,
          color: fallbackIconColor ?? Colors.grey.withOpacity(0.5),
        );
      },
    );
  }
}
