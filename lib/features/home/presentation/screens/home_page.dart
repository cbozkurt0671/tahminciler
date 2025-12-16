import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/service_locator.dart';
import '../../data/dummy_data.dart';
import '../../data/models/match_model.dart';
import '../../domain/repositories/match_repository.dart';
import '../../../groups/presentation/screens/groups_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../tournament/tournament_screen.dart';
import '../../../tournament/tournament_provider.dart';
import '../widgets/modern_match_card.dart';

/// Modern Home screen with Turkish localization and glassmorphism navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Repository instance
  late final MatchRepository _matchRepository;
  
  // State variables
  late List<MatchModel> _allMatches;
  late List<DateTime> _dateList;
  DateTime _selectedDate = DateTime.now();
  int _selectedStatusIndex = 0; // 0: Tümü, 1: Canlı, 2: Biten
  int _selectedNavIndex = 0; // Bottom navigation
  bool _isLoading = true;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _matchRepository = getMatchRepository();
    _generateDateList();
    _matchRepository.setSelectedDate(_selectedDate);
    _loadMatches();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Generate date list (Today + 14 days)
  void _generateDateList() {
    _dateList = [];
    final now = DateTime.now();
    for (int i = 0; i < 15; i++) {
      _dateList.add(DateTime(now.year, now.month, now.day + i));
    }
  }

  // Load matches from repository
  Future<void> _loadMatches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _allMatches = await _matchRepository.getMatches();
      print('✅ Loaded ${_allMatches.length} matches');
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading matches: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get filtered matches based on selected date and status
  List<MatchModel> _getFilteredMatches() {
    print('🔍 Filtering matches for: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} (Total matches: ${_allMatches.length})');
    
    // Match date format from API: "15 Ara, 2025"
    const monthNames = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    
    var filtered = _allMatches.where((match) {
      // Parse match date (format: "15 Ara, 2025")
      try {
        final parts = match.matchDate.split(' ');
        if (parts.length >= 3) {
          final day = int.parse(parts[0]);
          final monthStr = parts[1].replaceAll(',', '');
          final year = int.parse(parts[2]);
          
          // Find month index
          final monthIndex = monthNames.indexOf(monthStr);
          if (monthIndex == -1) {
            print('❌ Unknown month: $monthStr in ${match.matchDate}');
            return false;
          }
          
          final month = monthIndex + 1;
          
          final matches = day == _selectedDate.day && 
                         month == _selectedDate.month && 
                         year == _selectedDate.year;
          
          if (matches) {
            print('   ✅ Match found: ${match.homeTeam} vs ${match.awayTeam} (${match.matchDate}) - Status: ${match.status}');
          }
          return matches;
        }
      } catch (e) {
        print('❌ Error parsing date: ${match.matchDate} - $e');
      }
      return false;
    }).toList();

    print('📊 Filtered to ${filtered.length} matches for selected date');

    // If 'Tümü' is selected (index 0) do not filter by status — show all matches for the date
    if (_selectedStatusIndex == 1) {
      // Canlı
      filtered = filtered.where((m) => m.status?.toLowerCase() == 'live' || m.status?.toLowerCase() == 'inprogress').toList();
      print('🔴 Live filter: ${filtered.length} matches');
    } else if (_selectedStatusIndex == 2) {
      // Biten
      filtered = filtered.where((m) => m.status?.toLowerCase() == 'finished' || m.status?.toLowerCase() == 'ft').toList();
      print('� Finished filter: ${filtered.length} matches');
    } else {
      // Tümü (no additional filtering)
      print('⚪ All filter: ${filtered.length} matches (no status filter)');
    }

    // Sort matches chronologically by time (try to parse match.matchTime like "23:00")
    filtered.sort((a, b) {
      try {
        // Reuse the date parsing above to get year/month/day for both (they are same day)
        DateTime parseMatchDateTime(MatchModel m) {
          final parts = m.matchDate.split(' ');
          final day = int.tryParse(parts[0]) ?? _selectedDate.day;
          final monthStr = parts.length > 1 ? parts[1].replaceAll(',', '') : '';
          final year = parts.length > 2 ? int.tryParse(parts[2]) ?? _selectedDate.year : _selectedDate.year;
          const monthNames = [
            'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
            'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
          ];
          final monthIndex = monthNames.indexOf(monthStr);
          final month = monthIndex == -1 ? _selectedDate.month : monthIndex + 1;

          int hour = 0, minute = 0;
          if (m.matchTime != null && m.matchTime!.contains(':')) {
            final hm = m.matchTime!.split(':');
            hour = int.tryParse(hm[0]) ?? 0;
            minute = int.tryParse(hm.length > 1 ? hm[1] : '0') ?? 0;
          }

          return DateTime(year, month, day, hour, minute);
        }

        final da = parseMatchDateTime(a);
        final db = parseMatchDateTime(b);
        return da.compareTo(db);
      } catch (e) {
        return 0;
      }
    });

    return filtered;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  // Get date label (Bugün, Yarın, or date)
  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    if (_isSameDay(date, today)) {
      return 'Bugün';
    } else if (_isSameDay(date, tomorrow)) {
      return 'Yarın';
    } else {
      return DateFormat('dd MMM', 'tr_TR').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Content - Switch between screens based on selected nav index
          IndexedStack(
            index: _selectedNavIndex,
            children: [
              // 0: Maçlar (Home)
              _buildHomeContent(),
              // 1: Gruplar
              GroupsScreen(),
              // 2: Turnuva
              ChangeNotifierProvider(
                create: (_) => TournamentProvider(),
                child: const TournamentScreen(showAppBar: false),
              ),
              // 3: Liderlik (Placeholder)
              _buildPlaceholderScreen('Liderlik', Icons.leaderboard_rounded),
              // 4: Profil (ProfileScreen)
              ProfileScreen(),
            ],
          ),

          // Custom Bottom Navigation
          _buildCustomBottomNav(),
        ],
      ),
    );
  }

  // Home Content (Original matches screen)
  Widget _buildHomeContent() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Date Strip
          _buildDateStrip(),

          const SizedBox(height: 16),

          // Status Filter
          _buildStatusFilter(),

          const SizedBox(height: 16),

          // Match List
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _buildMatchList(),
          ),

          // Spacer for Bottom Nav
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // Placeholder Screen for未完成 tabs
  Widget _buildPlaceholderScreen(String title, IconData icon) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 32),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Yakında...',
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          // User Avatar - More compact (tap to open profile)
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
            child: Stack(
              children: [
                Container(
                  width: 35, // Reduced from 48
                  height: 35, // Reduced from 48
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5, // Thinner border
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20, // Reduced from 28
                  ),
                ),
                // Online Indicator (Green Dot)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10, // Reduced size
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759), // Green
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // Reduced from 12

          // Welcome Text - More compact
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hoş geldin,',
                  style: GoogleFonts.lexend(
                    fontSize: 10, // Reduced from 12
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 1), // Reduced from 2
                Text(
                  'Ahmet',
                  style: GoogleFonts.lexend(
                    fontSize: 14, // Reduced from 18
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Global Search Bar
          GestureDetector(
            onTap: () async {
              final result = await showSearch(
                context: context,
                delegate: GlobalSearchDelegate(DummyMatchData.getMatches()),
              );

              // If a date was returned from search, update the selected date
              if (result != null && result is DateTime) {
                setState(() {
                  _selectedDate = result;
                  _isLoading = true;
                });
                
                // Update repository date and fetch new matches
                _matchRepository.setSelectedDate(result);
                await _loadMatches();
              }
            },
            child: Container(
              width: 130,
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ara...',
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Notification Icon
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                  // Notification Dot
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cardSurface,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Date Strip
  Widget _buildDateStrip() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _dateList.length,
        itemBuilder: (context, index) {
          final date = _dateList[index];
          final isSelected = _isSameDay(date, _selectedDate);
          
          return GestureDetector(
            onTap: () async {
              if (!_isSameDay(date, _selectedDate)) {
                setState(() {
                  _selectedDate = date;
                  _isLoading = true;
                });
                
                // Update repository date and fetch new matches
                _matchRepository.setSelectedDate(date);
                await _loadMatches();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.cardSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _getDateLabel(date),
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Status Filter
  Widget _buildStatusFilter() {
    final filters = ['Tümü', 'Canlı', 'Biten'];
    final colors = [
      AppColors.textSecondary, // Neutral for Tümü
      const Color(0xFFFF3B30), // Red for Canlı
      const Color(0xFF34C759), // Green for Biten
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(3), // More compact
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(12), // Slightly smaller
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: filters.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isSelected = index == _selectedStatusIndex;
            final statusColor = colors[index];

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatusIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8), // More compact
                  decoration: BoxDecoration(
                    color: isSelected
                        ? statusColor.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: isSelected ? Border.all(
                      color: statusColor.withOpacity(0.4),
                      width: 1,
                    ) : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 5, // Smaller dot
                        height: 5,
                        margin: const EdgeInsets.only(right: 5), // Less margin
                        decoration: BoxDecoration(
                          color: isSelected ? statusColor : AppColors.textSecondary.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        label,
                        style: GoogleFonts.lexend(
                          fontSize: 12, // Smaller font
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? statusColor
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  // Match List
  Widget _buildMatchList() {
    final matches = _getFilteredMatches();
    
    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Maç bulunamadı',
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bu tarihte maç yok',
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Group matches by league/category so we show a single league header per group
    final groupedMatches = _groupMatchesByGroup(matches);

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: groupedMatches.keys.map((groupName) {
        final groupMatches = groupedMatches[groupName]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group header
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      _getLeagueLogo(groupName).isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset(
                                _getLeagueLogo(groupName),
                                width: 16,
                                height: 16,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.emoji_events_rounded, size: 14, color: const Color(0xFF00E676).withOpacity(0.8)),
                              ),
                            )
                          : Icon(Icons.emoji_events_rounded, size: 14, color: const Color(0xFF00E676).withOpacity(0.8)),
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
                      Icon(Icons.chevron_right, size: 16, color: const Color(0xFF666666)),
                    ],
                  ),
                ),
              ),
              // Matches under this group
              ...groupMatches.map((match) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: ModernMatchCard(
                      leagueName: '', // hide per-card league label since we show group header
                      leagueIcon: '', // do not show per-card league icon when group header exists
                      homeTeam: match.homeTeam,
                      awayTeam: match.awayTeam,
                      homeTeamLogo: _getTeamLogoUrl(match.homeTeamId),
                      awayTeamLogo: _getTeamLogoUrl(match.awayTeamId),
                      matchTime: match.matchTime,
                      matchDate: _getDateLabel(_selectedDate),
                      isLive: match.isLive || match.status?.toLowerCase() == 'live' || match.status?.toLowerCase() == 'inprogress',
                      liveMinute: match.liveMatchTime,
                      homeScore: match.homeScore,
                      awayScore: match.awayScore,
                      isUpcoming: match.status?.toLowerCase() == 'upcoming' || match.status?.toLowerCase() == 'scheduled' || match.status?.toLowerCase() == 'notstarted',
                      questions: match.questions,
                      userPredictedHomeScore: match.userPredictedHomeScore,
                      userPredictedAwayScore: match.userPredictedAwayScore,
                      onPredictionUpdated: (homeScore, awayScore) {
                        setState(() {
                          final matchIndex = _allMatches.indexWhere((m) => m.id == match.id);
                          if (matchIndex != -1) {
                            _allMatches[matchIndex] = _allMatches[matchIndex].copyWith(
                              userPredictedHomeScore: homeScore,
                              userPredictedAwayScore: awayScore,
                            );
                          }
                        });
                      },
                    ),
                  )).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Get team logo path (local asset or fallback to API)
  String? _getTeamLogoUrl(int? teamId) {
    if (teamId == null) return null;
    // Use local asset path - logo files are named by teamId
    return 'assets/images/team_logos/$teamId.png';
  }

  // Group matches by category/group so we render a single header per league
  Map<String, List<MatchModel>> _groupMatchesByGroup(List<MatchModel> matches) {
    final Map<String, List<MatchModel>> groups = {};

    for (final m in matches) {
      // Prefer category if available, otherwise fall back to group or a generic label
      String key = (m.category ?? '').trim();
      if (key.isEmpty) {
        key = (m.group ?? '').trim();
      }
      if (key.isEmpty) {
        key = 'Diğer';
      }

      // Normalize spacing and capitalization a bit to avoid accidental duplicates
      key = key.replaceAll(RegExp(r"\s+"), ' ').trim();

      groups.putIfAbsent(key, () => []).add(m);
    }

    // Sort each league group: live matches first, then by matchTime
    groups.forEach((league, matches) {
      matches.sort((a, b) {
        bool isALive = a.status?.toLowerCase() == 'live' || a.status?.toLowerCase() == 'inprogress';
        bool isBLive = b.status?.toLowerCase() == 'live' || b.status?.toLowerCase() == 'inprogress';
        if (isALive && !isBLive) return -1;
        if (!isALive && isBLive) return 1;
        // Fallback: sort by matchTime
        DateTime parseTime(String time) {
          final parts = time.split(':');
          int hour = int.tryParse(parts[0]) ?? 0;
          int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
          return DateTime(0, 1, 1, hour, minute);
        }
        return parseTime(a.matchTime).compareTo(parseTime(b.matchTime));
      });
    });

    return groups;
  }

  // Backwards-compatible alias used around the codebase: returns league logo path
  String _getLeagueLogo(String leagueName) {
    return _getLeagueIcon(leagueName);
  }

  // Get league icon path
  String _getLeagueIcon(String leagueName) {
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
        return '';
    }
  }

  // Custom Bottom Navigation with Glassmorphism
  Widget _buildCustomBottomNav() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSurface.withOpacity(0.95),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 70, // Fixed height for content
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Navigation Items Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Maçlar
                    _buildNavItem(
                      icon: Icons.sports_soccer_rounded,
                      label: 'Maçlar',
                      index: 0,
                    ),

                    // Gruplar
                    _buildNavItem(
                      icon: Icons.people_rounded,
                      label: 'Gruplar',
                      index: 1,
                    ),

                    // Turnuva
                    _buildNavItem(
                      icon: Icons.emoji_events_rounded,
                      label: 'Turnuva',
                      index: 2,
                    ),

                    // Liderlik
                    _buildNavItem(
                      icon: Icons.leaderboard_rounded,
                      label: 'Liderlik',
                      index: 3,
                    ),

                    // Profil
                    _buildNavItem(
                      icon: Icons.person_rounded,
                      label: 'Profil',
                      index: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigation Item
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Global Search Delegate
class GlobalSearchDelegate extends SearchDelegate {
  final List<MatchModel> allMatches;

  GlobalSearchDelegate(this.allMatches);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.lexend(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.lexend(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: AppColors.textPrimary),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    // Get unique team names
    final Set<String> teams = {};
    for (final match in allMatches) {
      teams.add(match.homeTeam);
      teams.add(match.awayTeam);
    }

    // Filter teams that start with query
    final filteredTeams = teams
        .where((team) => team.toLowerCase().startsWith(query.toLowerCase()))
        .toList()
      ..sort();

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        itemCount: filteredTeams.length,
        itemBuilder: (context, index) {
          final team = filteredTeams[index];
          return ListTile(
            leading: Icon(Icons.sports_soccer, color: AppColors.primary),
            title: Text(
              team,
              style: GoogleFonts.lexend(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            onTap: () {
              // Find next match for this team
              final teamMatches = allMatches
                  .where((match) => match.homeTeam == team || match.awayTeam == team)
                  .toList();

              if (teamMatches.isEmpty) {
                close(context, null);
                return;
              }

              // Sort by date
              teamMatches.sort((a, b) {
                final dateA = _parseMatchDate(a.matchDate);
                final dateB = _parseMatchDate(b.matchDate);
                return dateA.compareTo(dateB);
              });

              // Find first future match
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              MatchModel? nextMatch;
              for (final match in teamMatches) {
                final matchDate = _parseMatchDate(match.matchDate);
                if (matchDate.isAfter(today) || matchDate.isAtSameMomentAs(today)) {
                  nextMatch = match;
                  break;
                }
              }

              if (nextMatch != null) {
                final targetDate = _parseMatchDate(nextMatch.matchDate);
                close(context, targetDate);
              } else {
                // No future match
                close(context, null);
              }
            },
          );
        },
      ),
    );
  }

  DateTime _parseMatchDate(String matchDate) {
    const monthNames = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];

    try {
      final parts = matchDate.split(' ');
      if (parts.length >= 3) {
        final day = int.parse(parts[0]);
        final monthStr = parts[1].replaceAll(',', '');
        final year = int.parse(parts[2]);

        final monthIndex = monthNames.indexOf(monthStr);
        if (monthIndex == -1) return DateTime.now();

        final month = monthIndex + 1;

        return DateTime(year, month, day);
      }
    } catch (e) {
      // Ignore
    }
    return DateTime.now();
  }
}
