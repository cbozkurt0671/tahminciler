import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/service_locator.dart';
import '../../domain/repositories/match_repository.dart';
import '../../data/models/match_model.dart';
import '../widgets/home_header.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/expandable_match_card.dart';
import 'group_detail_screen.dart';

/// Home screen displaying the World Cup Dashboard
/// Features day-by-day fixture navigation with swipeable pages
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Repository instance (injected via service locator)
  late final MatchRepository _matchRepository;
  
  late List<MatchModel> _allMatches;
  late List<String> _uniqueDates;
  late Map<String, List<MatchModel>> _matchesByDate;
  late List<MatchModel> _heroMatches;
  late PageController _pageController;
  int _currentPageIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _matchKeys = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _matchRepository = getMatchRepository();
    _pageController = PageController(initialPage: 0);
    _loadMatches();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMatches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch matches from repository (could be Mock or PocketBase)
      _allMatches = await _matchRepository.getMatches();
      
      // Extract hero matches (those with isHero: true)
      _heroMatches = _allMatches.where((match) => match.isHero).toList();
      
      // Extract unique dates and sort them
      final Set<String> dateSet = {};
      for (final match in _allMatches) {
        dateSet.add(match.matchDate);
      }
      _uniqueDates = dateSet.toList()..sort((a, b) {
        // Parse dates for proper sorting (format: "12 Haz, 2026")
        return _parseDate(a).compareTo(_parseDate(b));
      });
      
      // Group matches by date
      _matchesByDate = {};
      for (final date in _uniqueDates) {
        final matchesOnDate = _allMatches
            .where((match) => match.matchDate == date && !match.isHero)
            .toList();
        _matchesByDate[date] = matchesOnDate;
        
        // Generate GlobalKeys for each match
        for (final match in matchesOnDate) {
          _matchKeys[match.id] = GlobalKey();
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading matches: $e');
      setState(() {
        _isLoading = false;
      });
      
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veriler yüklenemedi: $e')),
        );
      }
    }
  }
  
  /// Silently refresh matches without showing loading indicator
  Future<void> _refreshMatchesQuietly() async {
    try {
      // Fetch matches from repository
      _allMatches = await _matchRepository.getMatches();
      
      // Extract hero matches (those with isHero: true)
      _heroMatches = _allMatches.where((match) => match.isHero).toList();
      
      // Extract unique dates and sort them
      final Set<String> dateSet = {};
      for (final match in _allMatches) {
        dateSet.add(match.matchDate);
      }
      _uniqueDates = dateSet.toList()..sort((a, b) {
        return _parseDate(a).compareTo(_parseDate(b));
      });
      
      // Group matches by date
      _matchesByDate = {};
      for (final date in _uniqueDates) {
        final matchesOnDate = _allMatches
            .where((match) => match.matchDate == date && !match.isHero)
            .toList();
        _matchesByDate[date] = matchesOnDate;
        
        // Generate GlobalKeys for each match
        for (final match in matchesOnDate) {
          _matchKeys[match.id] = GlobalKey();
        }
      }

      // Update UI without loading indicator
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('❌ Error refreshing matches: $e');
    }
  }
  
  DateTime _parseDate(String dateStr) {
    // Parse Turkish date format: "12 Haz, 2026"
    try {
      final parts = dateStr.split(' ');
      final day = int.parse(parts[0]);
      final monthStr = parts[1].replaceAll(',', '');
      final year = int.parse(parts[2]);
      
      const monthMap = {
        'Oca': 1, 'Şub': 2, 'Mar': 3, 'Nis': 4, 'May': 5, 'Haz': 6,
        'Tem': 7, 'Ağu': 8, 'Eyl': 9, 'Eki': 10, 'Kas': 11, 'Ara': 12,
      };
      
      final month = monthMap[monthStr] ?? 6;
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  String _getWeekday(String dateStr) {
    final date = _parseDate(dateStr);
    const weekdays = [
      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 
      'Cuma', 'Cumartesi', 'Pazar'
    ];
    return weekdays[date.weekday - 1];
  }
  
  void _scrollToMatch(String matchId) {
    final key = _matchKeys[matchId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }
  
  void _goToNextDay() async {
    final repo = _matchRepository;
    
    // For SofaScore, fetch next day's data
    if (repo.runtimeType.toString().contains('SofaScore')) {
      final currentDate = (repo as dynamic).selectedDate as DateTime;
      final nextDate = currentDate.add(const Duration(days: 1));
      
      (repo as dynamic).setSelectedDate(nextDate);
      await _refreshMatchesQuietly();
      
      // Reset page after rebuild
      if (_uniqueDates.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && mounted) {
            setState(() {
              _currentPageIndex = 0;
            });
            _pageController.jumpToPage(0);
          }
        });
      }
    } else {
      // For other repos, just navigate pages
      if (_currentPageIndex < _uniqueDates.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
  
  void _goToPreviousDay() async {
    final repo = _matchRepository;
    
    // For SofaScore, fetch previous day's data
    if (repo.runtimeType.toString().contains('SofaScore')) {
      final currentDate = (repo as dynamic).selectedDate as DateTime;
      final prevDate = currentDate.subtract(const Duration(days: 1));
      
      (repo as dynamic).setSelectedDate(prevDate);
      await _refreshMatchesQuietly();
      
      // Reset page after rebuild
      if (_uniqueDates.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && mounted) {
            setState(() {
              _currentPageIndex = 0;
            });
            _pageController.jumpToPage(0);
          }
        });
      }
    } else {
      // For other repos, just navigate pages
      if (_currentPageIndex > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
  
  Future<void> _onDateChanged(int newIndex) async {
    // For SofaScore, we need to fetch data for the new date
    final repo = _matchRepository;
    if (repo.runtimeType.toString().contains('SofaScore')) {
      // Parse the new date from the index
      final dateStr = _uniqueDates[newIndex];
      final newDate = _parseDate(dateStr);
      
      // Update repository's selected date
      (repo as dynamic).setSelectedDate(newDate);
      
      // Reload matches for new date
      await _loadMatches();
      
      // Update page to show the correct date
      if (_uniqueDates.isNotEmpty) {
        _currentPageIndex = 0; // Reset to first page after reload
        _pageController.jumpToPage(0);
      }
    }
  }
  
  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF00E676),
              onPrimary: Colors.black,
              surface: const Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      // Update repository's selected date
      final repo = _matchRepository;
      if (repo.runtimeType.toString().contains('SofaScore')) {
        (repo as dynamic).setSelectedDate(picked);
        await _refreshMatchesQuietly();
        
        // Reset to first page after rebuild
        if (_uniqueDates.isNotEmpty && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients && mounted) {
              setState(() {
                _currentPageIndex = 0;
              });
              _pageController.jumpToPage(0);
            }
          });
        }
      }
    }
  }
  
  Map<String, List<MatchModel>> _groupMatchesByGroup(List<MatchModel> matches) {
    final Map<String, List<MatchModel>> grouped = {};
    for (var match in matches) {
      if (!grouped.containsKey(match.group)) {
        grouped[match.group] = [];
      }
      grouped[match.group]!.add(match);
    }
    return grouped;
  }

  Future<void> _handleScoreChanged(MatchModel match, int homeScore, int awayScore) async {
    // Save prediction via repository
    try {
      await _matchRepository.savePrediction(
        matchId: match.id,
        homeScore: homeScore,
        awayScore: awayScore,
      );

      // Update local state
      final index = _allMatches.indexWhere((m) => m.id == match.id);
      if (index != -1) {
        setState(() {
          _allMatches[index] = match.copyWith(
            homeScore: homeScore,
            awayScore: awayScore,
          );
        });
      }

      debugPrint('Score prediction for ${match.homeTeam} vs ${match.awayTeam}: $homeScore - $awayScore');
    } catch (e) {
      debugPrint('❌ Error saving prediction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tahmin kaydedilemedi')),
        );
      }
    }
  }

  Future<void> _handleExtraPredictionChanged(MatchModel match, String questionId, bool answer) async {
    // Save extra prediction via repository
    try {
      await _matchRepository.saveExtraPrediction(
        matchId: match.id,
        questionId: questionId,
        answer: answer,
      );

      debugPrint('Extra prediction for ${match.homeTeam} vs ${match.awayTeam}: $questionId = $answer');
    } catch (e) {
      debugPrint('❌ Error saving extra prediction: $e');
    }
  }

  Future<void> _handleFavoriteToggled(MatchModel match, bool isFavorite) async {
    try {
      await _matchRepository.toggleFavorite(match.id, isFavorite);

      final index = _allMatches.indexWhere((m) => m.id == match.id);
      if (index != -1) {
        setState(() {
          _allMatches[index] = match.copyWith(isFavorite: isFavorite);
        });
      }

      debugPrint('Favorite toggled for ${match.homeTeam} vs ${match.awayTeam}: $isFavorite');
    } catch (e) {
      debugPrint('❌ Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF00E676), // Neon green
              ),
              const SizedBox(height: 20),
              Text(
                'Maçlar yükleniyor...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Subtle star pattern background
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  painter: _StarPatternPainter(),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  const HomeHeader(),
                  
                  // Hero Carousel
                  if (_heroMatches.isNotEmpty) ...[
                    HeroCarousel(
                      heroMatches: _heroMatches,
                      onMatchTap: _scrollToMatch,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Date Navigation Header
                  _buildDateNavigationHeader(),
                  
                  const SizedBox(height: 12),
                  
                  // Day-by-Day PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      itemCount: _uniqueDates.length,
                      itemBuilder: (context, pageIndex) {
                        final date = _uniqueDates[pageIndex];
                        final matchesOnDate = _matchesByDate[date] ?? [];
                        
                        if (matchesOnDate.isEmpty) {
                          return _buildEmptyState();
                        }
                        
                        // Group matches on this date by group name
                        final groupedMatches = _groupMatchesByGroup(matchesOnDate);
                        
                        return _buildDayMatchList(groupedMatches);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDateNavigationHeader() {
    if (_uniqueDates.isEmpty) return const SizedBox.shrink();
    
    final currentDate = _uniqueDates[_currentPageIndex];
    final weekday = _getWeekday(currentDate);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00E676).withOpacity(0.15),
            const Color(0xFF00B8D4).withOpacity(0.10),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00E676).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Day Arrow
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: const Color(0xFF00E676),
              size: 28,
            ),
            onPressed: _goToPreviousDay,
          ),
          
          // Date Display
          // Date Display
          Expanded(
            child: GestureDetector(
              onTap: _showDatePicker,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentDate,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekday,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF00E676),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: const Color(0xFF00E676).withOpacity(0.7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Next Day Arrow
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: const Color(0xFF00E676),
              size: 28,
            ),
            onPressed: _goToNextDay,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy,
                size: 64,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bu Tarihte Maç Yok',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Takip edilen liglerde (Premier League, Süper Lig,\nBundesliga, Serie A) bu gün için maç bulunmuyor.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.4),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationButton(
                  icon: Icons.arrow_back,
                  label: 'Önceki Gün',
                  onPressed: _goToPreviousDay,
                ),
                const SizedBox(width: 16),
                _buildNavigationButton(
                  icon: Icons.calendar_today,
                  label: 'Tarih Seç',
                  onPressed: _showDatePicker,
                  isPrimary: true,
                ),
                const SizedBox(width: 16),
                _buildNavigationButton(
                  icon: Icons.arrow_forward,
                  label: 'Sonraki Gün',
                  onPressed: _goToNextDay,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? const Color(0xFF00E676).withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary
                  ? const Color(0xFF00E676).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary
                    ? const Color(0xFF00E676)
                    : Colors.white.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isPrimary
                      ? const Color(0xFF00E676)
                      : Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDayMatchList(Map<String, List<MatchModel>> groupedMatches) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: groupedMatches.keys.length,
      itemBuilder: (context, index) {
        final groupName = groupedMatches.keys.elementAt(index);
        final groupMatches = groupedMatches[groupName]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header (Clickable)
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetailScreen(
                        groupName: groupName,
                        matches: groupMatches,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00E676).withOpacity(0.15),
                        const Color(0xFF00B8D4).withOpacity(0.10),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF00E676).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        size: 18,
                        color: const Color(0xFF00E676),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        groupName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: const Color(0xFF00E676),
                              letterSpacing: 0.5,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: const Color(0xFF00E676).withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Group Matches
            ...groupMatches.map((match) {
              return ExpandableMatchCard(
                key: _matchKeys[match.id], // CRITICAL: Key must be on the StatefulWidget itself
                match: match,
                onScoreChanged: (homeScore, awayScore) {
                  _handleScoreChanged(match, homeScore, awayScore);
                },
                onExtraPredictionChanged: (question, answer) {
                  _handleExtraPredictionChanged(match, question, answer);
                },
                onFavoriteToggled: (isFavorite) {
                  _handleFavoriteToggled(match, isFavorite);
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

// ===========================
// Star Pattern Painter - WC 2026 Background Texture
// ===========================
class _StarPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw subtle star pattern across the canvas
    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        _drawStar(canvas, Offset(x, y), 8, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const numPoints = 5;
    final angle = 3.14159 * 2 / numPoints;

    for (int i = 0; i < numPoints * 2; i++) {
      final radius = i.isEven ? size : size / 2;
      final x = center.dx + radius * cos(angle * i - 3.14159 / 2);
      final y = center.dy + radius * sin(angle * i - 3.14159 / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
