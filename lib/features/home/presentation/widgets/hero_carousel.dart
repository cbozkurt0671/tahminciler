import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/utils/image_loader.dart';
import '../../data/models/match_model.dart';

/// Enhanced hero carousel for featured matches with dynamic content
/// Full PageView slider with hype texts and special questions
class HeroCarousel extends StatefulWidget {
  final List<MatchModel> heroMatches;
  final Function(String)? onMatchTap;

  const HeroCarousel({
    super.key,
    required this.heroMatches,
    this.onMatchTap,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
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
          height: 420, // Increased height for special question section
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                // Use compact hero card implementation available in this file
                child: _buildCompactHeroCard(match),
              );
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Page indicator dots
        if (widget.heroMatches.length > 1) _buildDotsIndicator(),
      ],
    );
  }

  Widget _buildCompactHeroCard(MatchModel match) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00205B), // US Navy
            Color(0xFFC8102E), // Canada Red
            Color(0xFF006847), // Mexico Green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content - Horizontal layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home Team
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCircularFlag(match.homeTeamId ?? 0),
                      const SizedBox(height: 6),
                      Text(
                        match.homeTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Center: Score/Status
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Score or "vs"
                      if (match.isLive || (match.homeScore != null && match.awayScore != null))
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${match.homeScore ?? 0}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '-',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${match.awayScore ?? 0}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'vs',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      
                      const SizedBox(height: 8),
                      
                      // Status: CANLI or Time
                      if (match.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF1744).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFF1744),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF1744),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'CANLI',
                                style: TextStyle(
                                  color: Color(0xFFFF1744),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          match.matchTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Away Team
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCircularFlag(match.awayTeamId ?? 0),
                      const SizedBox(height: 6),
                      Text(
                        match.awayTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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
          
          // City/Location footnote at bottom
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                match.city.toUpperCase() ?? '',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularFlag(int teamId) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedTeamLogoWidget(
          teamId: teamId,
          size: 40,
          fit: BoxFit.cover,
          fallbackIconColor: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.heroMatches.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: _currentPage == index
                ? const LinearGradient(
                    colors: [
                      Color(0xFF00205B), // US Navy
                      Color(0xFFC8102E), // Canada Red
                      Color(0xFF006847), // Mexico Green
                    ],
                  )
                : null,
            color: _currentPage == index
                ? null
                : Colors.white.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
