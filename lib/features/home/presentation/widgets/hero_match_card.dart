import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/match_model.dart';

/// Compact hero banner displaying the featured live match
/// Slim horizontal format with gradient background
class HeroMatchCard extends StatelessWidget {
  final MatchModel match;

  const HeroMatchCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      decoration: BoxDecoration(
        // WC 2026 Fusion Gradient (USA Navy → Canada Red → Mexico Green)
        gradient: const LinearGradient(
          colors: [
            Color(0xFF001F3F), // US Navy (darker for readability)
            Color(0xFF8B0000), // Canada Red (darker)
            Color(0xFF004D2C), // Mexico Green (darker)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Home Team
                  SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            match.homeFlagUrl,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.flag,
                                size: 28,
                                color: Colors.white.withOpacity(0.5),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match.homeTeam,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Center Score Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Live indicator
                        if (match.isLive)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'CANLI',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9,
                                      letterSpacing: 0.8,
                                    ),
                              ),
                            ],
                          ),
                        if (match.isLive) const SizedBox(height: 4),
                        // Score
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${match.homeScore ?? 0}',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '-',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                    ),
                              ),
                            ),
                            Text(
                              '${match.awayScore ?? 0}',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Time
                        Text(
                          match.matchTime,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 4),
                        // City Badge - WC 2026
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 10,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                match.city.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Away Team
                  SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            match.awayFlagUrl,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.flag,
                                size: 28,
                                color: Colors.white.withOpacity(0.5),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match.awayTeam,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
