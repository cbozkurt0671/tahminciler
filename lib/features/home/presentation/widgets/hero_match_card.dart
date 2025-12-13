import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_loader.dart';
import '../../data/models/match_model.dart';

/// Compact hero banner displaying the featured live match
/// Slim horizontal format with gradient background
class HeroMatchCard extends StatefulWidget {
  final MatchModel match;

  const HeroMatchCard({
    super.key,
    required this.match,
  });

  @override
  State<HeroMatchCard> createState() => _HeroMatchCardState();
}

class _HeroMatchCardState extends State<HeroMatchCard> {
  String? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Existing Match Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Home Team
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedTeamLogoWidget(
                          teamId: widget.match.homeTeamId ?? 0,
                          size: 30,
                          fit: BoxFit.contain,
                          fallbackIconColor: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.match.homeTeam,
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
                        if (widget.match.isLive)
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
                        if (widget.match.isLive) const SizedBox(height: 4),
                        // Score
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.match.homeScore ?? 0}',
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
                              '${widget.match.awayScore ?? 0}',
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
                          widget.match.matchTime,
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
                                widget.match.city.toUpperCase(),
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
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedTeamLogoWidget(
                          teamId: widget.match.awayTeamId ?? 0,
                          size: 30,
                          fit: BoxFit.contain,
                          fallbackIconColor: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.match.awayTeam,
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

            // Special Question Section
            Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A24),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      const Text(
                        '🔥 ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: Text(
                          'GÜNÜN FIRSAT SORUSU',
                          style: TextStyle(
                            color: const Color(0xFFFFD700),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+50 PUAN',
                          style: TextStyle(
                            color: const Color(0xFFFFD700),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Question
                  Text(
                    'Toplam gol sayısı 2.5 üstü olur mu?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Answer Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnswerButton(
                          context,
                          label: 'EVET',
                          value: 'yes',
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAnswerButton(
                          context,
                          label: 'HAYIR',
                          value: 'no',
                          icon: Icons.cancel_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedAnswer == value;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedAnswer = value;
          });
          debugPrint('🎯 Günün Sorusu Cevabı: $label');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Cevabınız kaydedildi: $label (+50 Puan)'),
              duration: const Duration(seconds: 2),
              backgroundColor: const Color(0xFFFFD700),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFD700).withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? const Color(0xFFFFD700)
                    : Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFFD700)
                      : Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
