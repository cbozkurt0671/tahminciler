import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/service_locator.dart';
import '../../domain/repositories/match_repository.dart';
import '../../data/models/match_model.dart';
import '../widgets/home_header.dart';
import '../widgets/hero_carousel_enhanced.dart';
import '../widgets/expandable_match_card.dart';
import 'group_detail_screen.dart';
import '../../../tournament/tournament_screen.dart';
import 'package:provider/provider.dart';
import '../../../tournament/tournament_provider.dart';

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
  int _selectedBottomNavIndex = 0; // Bottom Navigation state
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
      
      print('⭐ Found ${_heroMatches.length} hero matches');
      
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
            .where((match) => match.matchDate == date)
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
            .where((match) => match.matchDate == date)
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
      
      print('📅 Going to next day: ${DateFormat('dd/MM/yyyy').format(nextDate)}');
      
      (repo as dynamic).setSelectedDate(nextDate);
      await _refreshMatchesQuietly();
      
      // Force UI update even if no matches
      if (mounted) {
        setState(() {
          _currentPageIndex = 0;
        });
      }
      
      // Reset page after rebuild (if there are dates)
      if (_uniqueDates.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && mounted) {
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
      
      print('📅 Going to previous day: ${DateFormat('dd/MM/yyyy').format(prevDate)}');
      
      (repo as dynamic).setSelectedDate(prevDate);
      await _refreshMatchesQuietly();
      
      // Force UI update even if no matches
      if (mounted) {
        setState(() {
          _currentPageIndex = 0;
        });
      }
      
      // Reset page after rebuild (if there are dates)
      if (_uniqueDates.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && mounted) {
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
  
  /// Get league logo path based on league name
  String _getLeagueLogo(String leagueName) {
    print('🏆 League Logo Request: "$leagueName"');
    switch (leagueName) {
      case 'Premier League':
        return 'assets/images/league_logos/premier_league.png';
      case 'Süper Lig':
        return 'assets/images/league_logos/super_lig.png';
      case 'Bundesliga':
        return 'assets/images/league_logos/bundesliga.png';
      case 'Serie A':
        return 'assets/images/league_logos/serie_a.png';
      case 'La Liga':
        return 'assets/images/league_logos/la_liga.png';
      case 'Ligue 1':
        return 'assets/images/league_logos/ligue_1.png';
      default:
        print('⚠️ No logo found for: "$leagueName"');
        return '';
    }
  }
  
  Map<String, List<MatchModel>> _groupMatchesByGroup(List<MatchModel> matches) {
    final Map<String, List<MatchModel>> grouped = {};
    for (var match in matches) {
      // Prefer grouping by league/category when available (e.g., "Premier League").
      final key = (match.category != null && match.category!.isNotEmpty) ? match.category! : match.group;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(match);
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
                color: Color(0xFF0df259), // Neon green
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

    // Get the body content based on selected index
    Widget bodyContent;
    switch (_selectedBottomNavIndex) {
      case 0:
        bodyContent = _buildMatchesBody();
        break;
      case 1:
        bodyContent = _buildGroupsBody();
        break;
      case 2:
        bodyContent = _buildTournamentBody();
        break;
      case 3:
        bodyContent = _buildLeaderboardBody();
        break;
      case 4:
        bodyContent = _buildProfileBody();
        break;
      default:
        bodyContent = _buildMatchesBody();
    }

    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: bodyContent,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (index) {
            setState(() {
              _selectedBottomNavIndex = index;
            });
            debugPrint('📱 Bottom Nav tapped: $index');
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A1A24),
          selectedItemColor: const Color(0xFF0df259),
          unselectedItemColor: Colors.white.withOpacity(0.4),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer),
              label: 'Maçlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Gruplar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Turnuva',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Liderlik',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesBody() {
    return Stack(
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
        // Main content with CustomScrollView
        SafeArea(
          child: Column(
            children: [
              // Header - Always visible at top
              const HomeHeader(),
              
              const SizedBox(height: 8),
              
              // Scrollable content
              Expanded(
                child: _uniqueDates.isEmpty
                    ? _buildNoDataAtAllState()
                    : PageView.builder(
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
                          
                          return _buildSliverScrollView(groupedMatches);
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsBody() {
    return SafeArea(
      child: Center(
        child: Text('Gruplar - Çok Yakında', style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildTournamentBody() {
    return ChangeNotifierProvider(
      create: (_) => TournamentProvider(),
      child: const TournamentScreen(showAppBar: true),
    );
  }

  Widget _buildLeaderboardBody() {
    return SafeArea(
      child: Center(
        child: Text('Liderlik Tablosu - Çok Yakında', style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildProfileBody() {
    return SafeArea(
      child: Center(
        child: Text('Profil - Çok Yakında', style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  /// CustomScrollView with Sliver structure for smooth scrolling
  Widget _buildSliverScrollView(Map<String, List<MatchModel>> groupedMatches) {
    // If no matches, show empty state within sliver
    if (groupedMatches.isEmpty) {
      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Hero Carousel (3-5 featured matches)
                if (_heroMatches.isNotEmpty) ...[
                  HeroCarouselEnhanced(
                    heroMatches: _heroMatches,
                    onMatchTap: _scrollToMatch,
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Compact Date Navigation - Right above "Günün Maçları"
                _buildCompactDateNavigation(),
                
                const SizedBox(height: 8),
                
                // "Günün Maçları" Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 20,
                        color: const Color(0xFF00E676),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Günün Maçları',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF00E676).withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Empty state message
                _buildEmptyStateInline(),
              ],
            ),
          ),
        ],
      );
    }
    
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Fixed content at top (scrolls away)
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Hero Carousel (3-5 featured matches)
              if (_heroMatches.isNotEmpty) ...[
                HeroCarouselEnhanced(
                  heroMatches: _heroMatches,
                  onMatchTap: _scrollToMatch,
                ),
                const SizedBox(height: 16),
              ],
              
              // Compact Date Navigation - Right above "Günün Maçları"
              _buildCompactDateNavigation(),
              
              const SizedBox(height: 8),
              
              // "Günün Maçları" Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: const Color(0xFF00E676),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Günün Maçları',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00E676).withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
            ],
          ),
        ),
        
        // Match list (scrollable)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final groupName = groupedMatches.keys.elementAt(index);
              final groupMatches = groupedMatches[groupName]!;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Header - Minimal SofaScore Style
                    Padding(
                      padding: EdgeInsets.only(bottom: 4, top: index == 0 ? 0 : 6),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupDetailScreen(
                                groupName: groupName,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              // League Logo (Local Asset)
                              _getLeagueLogo(groupName).isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.asset(
                                      _getLeagueLogo(groupName),
                                      width: 16,
                                      height: 16,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        print('❌ ERROR loading logo for "$groupName": $error');
                                        print('   Path: ${_getLeagueLogo(groupName)}');
                                        return Icon(
                                          Icons.emoji_events_rounded,
                                          size: 14,
                                          color: const Color(0xFF00E676).withOpacity(0.8),
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.emoji_events_rounded,
                                    size: 14,
                                    color: const Color(0xFF00E676).withOpacity(0.8),
                                  ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  groupName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB0B0B0),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: const Color(0xFF666666),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Group Matches
                    ...groupMatches.asMap().entries.map((entry) {
                      final matchIndex = entry.key;
                      final match = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: matchIndex == groupMatches.length - 1 ? 2 : 6,
                        ),
                        child: ExpandableMatchCard(
                          key: _matchKeys[match.id], // Use GlobalKey for state preservation
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
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
            childCount: groupedMatches.keys.length,
          ),
        ),
        
        // Bottom padding for safe area
        SliverToBoxAdapter(
          child: const SizedBox(height: 20),
        ),
      ],
    );
  }
  
  /// Compact Date Navigation - Thin horizontal bar above match list
  Widget _buildCompactDateNavigation() {
    if (_uniqueDates.isEmpty) return const SizedBox.shrink();
    
    final currentDate = _uniqueDates[_currentPageIndex];
    final weekday = _getWeekday(currentDate);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Day Arrow
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF00E676),
              size: 18,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: _goToPreviousDay,
          ),
          
          // Date Display (Horizontal)
          Flexible(
            child: GestureDetector(
              onTap: _showDatePicker,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      currentDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    weekday,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF00E676),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.calendar_today,
                    size: 11,
                    color: const Color(0xFF00E676).withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
          
          // Next Day Arrow
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: Color(0xFF00E676),
              size: 18,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: _goToNextDay,
          ),
        ],
      ),
    );
  }
  
  /// State when no data at all from API (all leagues filtered out)
  Widget _buildNoDataAtAllState() {
    // Get the current selected date from repository
    String displayDate;
    final repo = _matchRepository;
    
    if (repo.runtimeType.toString().contains('SofaScore')) {
      final selectedDate = (repo as dynamic).selectedDate as DateTime;
      displayDate = DateFormat('d/M/yyyy').format(selectedDate);
    } else {
      displayDate = DateFormat('d/M/yyyy').format(DateTime.now());
    }
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Show current selected date
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: const Color(0xFF00E676).withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      displayDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // "Günün Maçları" Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: const Color(0xFF00E676),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Günün Maçları',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00E676).withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Empty state message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.event_busy_rounded,
                          size: 48,
                          color: const Color(0xFF00E676).withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Bu Tarihte Maç Yok',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Takip edilen liglerde bu tarih için\nmaç bulunmuyor.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.4),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _goToPreviousDay,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white.withOpacity(0.7),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.arrow_back, size: 16),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Önceki',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _loadMatches,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Yenile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00E676).withOpacity(0.15),
                                foregroundColor: const Color(0xFF00E676),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: const Color(0xFF00E676).withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _goToNextDay,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white.withOpacity(0.7),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Sonraki',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Inline empty state for when there are no matches
  Widget _buildEmptyStateInline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 48,
                color: const Color(0xFF00E676).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bu Tarihte Maç Yok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Takip edilen liglerde bu tarih için\nmaç bulunmuyor.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.4),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _goToPreviousDay,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Önceki'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.7),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _showDatePicker,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Tarih Seç'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676).withOpacity(0.15),
                      foregroundColor: const Color(0xFF00E676),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: const Color(0xFF00E676).withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _goToNextDay,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Sonraki'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.7),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
  bool shouldRepaint(covariant _StarPatternPainter oldDelegate) => false;
}
