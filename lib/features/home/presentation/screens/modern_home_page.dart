import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../widgets/modern_match_card.dart';
import 'package:world_cup_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:world_cup_app/features/groups/presentation/screens/groups_screen.dart';
import 'package:world_cup_app/features/tournament/tournament_screen.dart';
import 'package:world_cup_app/features/tournament/tournament_provider.dart';
import 'package:world_cup_app/features/profile/presentation/screens/profile_screen.dart';

class ModernHomePage extends StatefulWidget {
  const ModernHomePage({super.key});

  @override
  State<ModernHomePage> createState() => _ModernHomePageState();
}

class _ModernHomePageState extends State<ModernHomePage> {
  int _selectedDateIndex = 2; // Today is selected by default
  int _selectedStatusIndex = 1; // Upcoming is selected by default
  int _selectedNavIndex = 0; // Home is selected

  final List<String> _dates = [
    '13 Dec',
    '14 Dec',
    'Today',
    '16 Dec',
    '17 Dec',
  ];

  final List<String> _statusFilters = ['Live', 'Upcoming', 'Finished'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
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

                // Main Content switched by bottom nav
                Expanded(
                  child: _buildBodyByIndex(),
                ),

                // Spacer for Bottom Nav
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Custom Bottom Navigation with Floating Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCustomBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyByIndex() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildMatchList();
      case 1:
        return GroupsScreen();
      case 2:
        return ChangeNotifierProvider(
          create: (_) => TournamentProvider(),
          child: const TournamentScreen(showAppBar: false),
        );
      case 3:
        return Center(child: Text('Leaderboard - Coming Soon', style: TextStyle(color: AppColors.textSecondary)));
      case 4:
        return ProfileScreen();
      default:
        return _buildMatchList();
    }
  }

  // Header Section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ahmet',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Points Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber[400],
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '1,250 P',
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
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
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedDateIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDateIndex = index;
              });
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
                  _dates[index],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: _statusFilters.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isSelected = index == _selectedStatusIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatusIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (index == 0 && isSelected)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        label,
                        style: GoogleFonts.lexend(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.background
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

  // Match List
  Widget _buildMatchList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Live Match Example
        if (_selectedStatusIndex == 0)
          ModernMatchCard(
            leagueName: 'Premier League',
            leagueIcon: 'assets/images/league_logos/premier_league.png',
            homeTeam: 'Manchester United',
            awayTeam: 'Liverpool',
            homeTeamLogo: 'https://api.sofascore.com/api/v1/team/35/image',
            awayTeamLogo: 'https://api.sofascore.com/api/v1/team/44/image',
            matchTime: '20:45',
            matchDate: 'Today',
            isLive: true,
            liveMinute: '78',
            homeScore: 2,
            awayScore: 1,
            isUpcoming: false,
          ),

        // Upcoming Matches Example
        if (_selectedStatusIndex == 1) ...[
          ModernMatchCard(
            leagueName: 'Premier League',
            leagueIcon: 'assets/images/league_logos/premier_league.png',
            homeTeam: 'Manchester United',
            awayTeam: 'Bournemouth',
            homeTeamLogo: 'https://api.sofascore.com/api/v1/team/35/image',
            awayTeamLogo: 'https://api.sofascore.com/api/v1/team/60/image',
            matchTime: '23:00',
            matchDate: 'Today',
            isUpcoming: true,
          ),
          ModernMatchCard(
            leagueName: 'Serie A',
            leagueIcon: 'assets/images/league_logos/serie_a.png',
            homeTeam: 'Roma',
            awayTeam: 'Como',
            homeTeamLogo: 'https://api.sofascore.com/api/v1/team/2702/image',
            awayTeamLogo: 'https://api.sofascore.com/api/v1/team/2704/image',
            matchTime: '22:45',
            matchDate: 'Today',
            isUpcoming: true,
          ),
          ModernMatchCard(
            leagueName: 'Süper Lig',
            leagueIcon: 'assets/images/league_logos/super_lig.png',
            homeTeam: 'Fenerbahçe',
            awayTeam: 'Konyaspor',
            homeTeamLogo: 'https://api.sofascore.com/api/v1/team/3052/image',
            awayTeamLogo: 'https://api.sofascore.com/api/v1/team/3085/image',
            matchTime: '20:00',
            matchDate: 'Today',
            isUpcoming: true,
          ),
        ],

        // Finished Matches Example
        if (_selectedStatusIndex == 2)
          ModernMatchCard(
            leagueName: 'Premier League',
            leagueIcon: 'assets/images/league_logos/premier_league.png',
            homeTeam: 'Arsenal',
            awayTeam: 'Chelsea',
            homeTeamLogo: 'https://api.sofascore.com/api/v1/team/42/image',
            awayTeamLogo: 'https://api.sofascore.com/api/v1/team/38/image',
            matchTime: '18:30',
            matchDate: 'Yesterday',
            homeScore: 3,
            awayScore: 1,
            isUpcoming: false,
          ),
      ],
    );
  }

  // Custom Bottom Navigation with Glassmorphism
  Widget _buildCustomBottomNav() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Glassmorphism Background
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardSurface.withOpacity(0.8),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Home
                      _buildNavItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        index: 0,
                      ),

                      // Groups
                      _buildNavItem(
                        icon: Icons.people_rounded,
                        label: 'Groups',
                        index: 1,
                      ),

                      // Spacer for FAB
                      const SizedBox(width: 60),

                      // Turnuva
                      _buildNavItem(
                        icon: Icons.emoji_events_rounded,
                        label: 'Turnuva',
                        index: 2,
                      ),

                      // Spacer for FAB
                      const SizedBox(width: 8),

                      // Leaderboard
                      _buildNavItem(
                        icon: Icons.leaderboard_rounded,
                        label: 'Leaderboard',
                        index: 3,
                      ),

                      // Profile
                      _buildNavItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        index: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Floating Action Button (Breaking the nav bar)
        Positioned(
          top: -28,
          child: GestureDetector(
            onTap: () {
              // TODO: Quick Prediction Action
              print('Quick Prediction Tapped!');
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
          ),
        ),
      ],
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
