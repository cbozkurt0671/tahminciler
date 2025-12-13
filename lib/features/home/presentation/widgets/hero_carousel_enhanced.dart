import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_loader.dart';
import '../../data/models/match_model.dart';

/// Enhanced hero carousel for featured matches with dynamic content
/// Full PageView slider with hype texts and special questions
class HeroCarouselEnhanced extends StatefulWidget {
  final List<MatchModel> heroMatches;
  final Function(String)? onMatchTap;

  const HeroCarouselEnhanced({
    super.key,
    required this.heroMatches,
    this.onMatchTap,
  });

  @override
  State<HeroCarouselEnhanced> createState() => _HeroCarouselEnhancedState();
}

class _HeroCarouselEnhancedState extends State<HeroCarouselEnhanced> {
  late PageController _pageController;
  int _currentPage = 0;
  final Map<String, String?> _selectedAnswers = {};

  // Hype texts for different matches
  final List<String> _hypeTexts = [
    '🔥 Derbi Ateşi',
    '💎 Günün Bankosu',
    '⚡ Şok Sonuç Bekleniyor',
    '🎯 Kritik Karşılaşma',
    '👑 Liderlik Mücadelesi',
    '⭐ Yıldızlar Sahada',
    '🚀 Gol Yağmuru Geliyor',
    '💪 Dev Kapışma',
  ];

  // Special questions for each match
  final List<Map<String, dynamic>> _specialQuestions = [
    {
      'question': 'Toplam gol sayısı 2.5 üstü olur mu?',
      'options': ['EVET', 'HAYIR'],
      'icon': Icons.sports_soccer,
    },
    {
      'question': 'İlk golü hangi takım atar?',
      'options': ['EV SAHİBİ', 'DEPLASMAN'],
      'icon': Icons.flag,
    },
    {
      'question': 'Maçta kırmızı kart çıkar mı?',
      'options': ['ÇIKAR', 'ÇIKMAZ'],
      'icon': Icons.credit_card,
    },
    {
      'question': 'Her iki takım da gol atar mı?',
      'options': ['EVET', 'HAYIR'],
      'icon': Icons.compare_arrows,
    },
    {
      'question': 'İlk yarı golsüz biter mi?',
      'options': ['EVET', 'HAYIR'],
      'icon': Icons.timer,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getHypeText(int index) {
    final random = Random(index);
    return _hypeTexts[random.nextInt(_hypeTexts.length)];
  }

  Map<String, dynamic> _getSpecialQuestion(int index) {
    final random = Random(index);
    return _specialQuestions[random.nextInt(_specialQuestions.length)];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.heroMatches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Enhanced Hero Carousel with special questions
        SizedBox(
          height: 230, // Further reduced to 230px
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.heroMatches.length,
            itemBuilder: (context, index) {
              final match = widget.heroMatches[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildEnhancedHeroCard(match, index),
              );
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Page indicator dots
        if (widget.heroMatches.length > 1) _buildPageIndicator(),
      ],
    );
  }

  Widget _buildEnhancedHeroCard(MatchModel match, int index) {
    final hypeText = _getHypeText(index);
    final specialQuestion = _getSpecialQuestion(index);
    final gradientColors = _getGradientColors(index);
    final badgeGradient = _getBadgeGradient(index);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        child: Column(
          children: [
            // Hype Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: badgeGradient,
                ),
              ),
              child: Text(
                hypeText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1A1A24),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            
            // Match Info Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // League Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        match.group,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Teams and Score Row
                    Flexible(
                      child: Row(
                        children: [
                          // Home Team
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedTeamLogoWidget(
                                  teamId: match.homeTeamId ?? 0,
                                  size: 32,
                                  fit: BoxFit.contain,
                                  fallbackIconColor: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  match.homeTeam,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          // Score/Time Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Score or VS display
                                if (match.homeScore != null && match.awayScore != null && 
                                    (match.homeScore! > 0 || match.awayScore! > 0 || match.isLive))
                                  // Show score if match has started or is live
                                  Row(
                                    children: [
                                      Text(
                                        '${match.homeScore}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 24,
                                          height: 1.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 3),
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${match.awayScore}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 24,
                                          height: 1.0,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  // Show VS if match hasn't started
                                  Text(
                                    'VS',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      letterSpacing: 1.5,
                                      height: 1.0,
                                    ),
                                  ),
                                
                                const SizedBox(height: 3),
                                
                                // Show live match time or regular match time
                                Text(
                                  match.isLive && match.liveMatchTime != null 
                                      ? match.liveMatchTime! 
                                      : match.matchTime,
                                  style: TextStyle(
                                    color: match.isLive 
                                        ? const Color(0xFF00E676) 
                                        : Colors.white.withOpacity(0.8),
                                    fontSize: 9,
                                    fontWeight: match.isLive ? FontWeight.w900 : FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Away Team
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedTeamLogoWidget(
                                  teamId: match.awayTeamId ?? 0,
                                  size: 32,
                                  fit: BoxFit.contain,
                                  fallbackIconColor: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  match.awayTeam,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 5),
                    
                    // Live Badge (instead of City Badge)
                    if (match.isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'CANLI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // City Badge for non-live matches
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(7),
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
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Special Question Section
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A24),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Row(
                    children: [
                      Icon(
                        specialQuestion['icon'] as IconData,
                        color: const Color(0xFFFFD700),
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'GÜNÜN SORUSU',
                          style: TextStyle(
                            color: const Color(0xFFFFD700),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '+50',
                          style: TextStyle(
                            color: const Color(0xFFFFD700),
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  
                  // Question
                  Text(
                    specialQuestion['question'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Answer Buttons
                  Row(
                    children: (specialQuestion['options'] as List<String>).map((option) {
                      final isSelected = _selectedAnswers[match.id] == option;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _buildAnswerButton(
                            context,
                            label: option,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedAnswers[match.id] = option;
                              });
                              debugPrint('🎯 ${match.homeTeam} vs ${match.awayTeam} - ${specialQuestion['question']}: $option');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('✅ Cevabınız: $option (+50 Puan)'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: const Color(0xFFFFD700),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
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
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFD700).withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 1.5 : 0.8,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.9),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.heroMatches.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _currentPage == index ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFFFFD700)
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
  
  /// Get dynamic gradient colors for each match card
  List<Color> _getGradientColors(int index) {
    final gradients = [
      // 1. US Navy + Canada Red + Mexico Green
      [
        const Color(0xFF001F3F), // US Navy (darker)
        const Color(0xFF8B0000), // Canada Red (darker)
        const Color(0xFF004D2C), // Mexico Green (darker)
      ],
      // 2. Deep Purple + Midnight Blue
      [
        const Color(0xFF1A0033), // Deep Purple
        const Color(0xFF0D1B4D), // Midnight Blue
        const Color(0xFF4A0080), // Royal Purple
      ],
      // 3. Dark Teal + Ocean Blue
      [
        const Color(0xFF004D4D), // Dark Teal
        const Color(0xFF001A33), // Deep Ocean
        const Color(0xFF006666), // Teal
      ],
      // 4. Burgundy + Wine + Dark Rose
      [
        const Color(0xFF4D0000), // Deep Burgundy
        const Color(0xFF330033), // Wine
        const Color(0xFF660033), // Dark Rose
      ],
      // 5. Forest Green + Dark Emerald
      [
        const Color(0xFF002600), // Deep Forest
        const Color(0xFF004D00), // Forest Green
        const Color(0xFF001A00), // Dark Emerald
      ],
    ];
    
    return gradients[index % gradients.length];
  }
  
  /// Get dynamic badge gradient for each match
  List<Color> _getBadgeGradient(int index) {
    final badgeGradients = [
      // Gold gradient
      [
        const Color(0xFFFFD700).withOpacity(0.9),
        const Color(0xFFFFA500).withOpacity(0.9),
      ],
      // Purple gradient
      [
        const Color(0xFFAB47BC).withOpacity(0.9),
        const Color(0xFF7B1FA2).withOpacity(0.9),
      ],
      // Cyan gradient
      [
        const Color(0xFF00E5FF).withOpacity(0.9),
        const Color(0xFF00B8D4).withOpacity(0.9),
      ],
      // Pink gradient
      [
        const Color(0xFFFF4081).withOpacity(0.9),
        const Color(0xFFF50057).withOpacity(0.9),
      ],
      // Green gradient
      [
        const Color(0xFF69F0AE).withOpacity(0.9),
        const Color(0xFF00E676).withOpacity(0.9),
      ],
    ];
    
    return badgeGradients[index % badgeGradients.length];
  }
}
