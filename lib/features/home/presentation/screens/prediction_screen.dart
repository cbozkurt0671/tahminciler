import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_cup_app/core/theme/app_colors.dart';
import 'package:world_cup_app/features/home/presentation/screens/home_page.dart';
import 'package:world_cup_app/features/groups/presentation/screens/groups_screen.dart';
import 'package:world_cup_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:world_cup_app/features/notifications/presentation/screens/notifications_screen.dart';

/// Prediction Detail Screen - Match prediction with score input
/// Features: Custom AppBar, Score Counters, Community Stats, Sticky Bottom Bar
class PredictionScreen extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final String league;
  final String week;
  final String matchTime;
  final int? initialHomeScore;
  final int? initialAwayScore;
  final bool? isFinished;

  const PredictionScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    this.league = 'Süper Lig',
    this.week = 'Week 37',
    this.matchTime = '19:00',
    this.initialHomeScore,
    this.initialAwayScore,
    this.isFinished,
  });

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  int _homeScore = 0;
  int _awayScore = 0;
  int _selectedTab = 0; // 0: Score Prediction, 1: Match Result
  int _selectedBottomNavIndex = 0; // Bottom navigation selected index

  // Community stats (mock data)
  final double _homeWinPercentage = 65.0;
  final double _drawPercentage = 20.0;
  final double _awayWinPercentage = 15.0;

  // Helper function to get team-specific colors
  Color getTeamColor(String teamName) {
    final lowerName = teamName.toLowerCase();
    if (lowerName.contains('galatasaray')) {
      return const Color(0xFFA90432); // Galatasaray Red
    } else if (lowerName.contains('fenerbahçe') || lowerName.contains('fenerbahce')) {
      return const Color(0xFF002D72); // Fenerbahçe Blue
    } else if (lowerName.contains('beşiktaş') || lowerName.contains('besiktas')) {
      return const Color(0xFF1A1A1A); // Beşiktaş Dark Grey/Black
    } else if (lowerName.contains('trabzonspor')) {
      return const Color(0xFF81172B); // Trabzonspor Burgundy
    } else if (lowerName.contains('barcelona')) {
      return const Color(0xFFA50044); // Barcelona Red
    } else if (lowerName.contains('real madrid')) {
      return const Color(0xFFFEBE10); // Real Madrid Gold
    } else if (lowerName.contains('bayern')) {
      return const Color(0xFFDC052D); // Bayern Red
    } else if (lowerName.contains('liverpool')) {
      return const Color(0xFFC8102E); // Liverpool Red
    } else if (lowerName.contains('chelsea')) {
      return const Color(0xFF034694); // Chelsea Blue
    } else if (lowerName.contains('manchester united')) {
      return const Color(0xFFDA291C); // Man United Red
    } else if (lowerName.contains('manchester city')) {
      return const Color(0xFF6CABDD); // Man City Sky Blue
    } else if (lowerName.contains('arsenal')) {
      return const Color(0xFFEF0107); // Arsenal Red
    } else if (lowerName.contains('juventus')) {
      return const Color(0xFF000000); // Juventus Black
    } else if (lowerName.contains('inter')) {
      return const Color(0xFF0068A8); // Inter Blue
    } else if (lowerName.contains('milan') && !lowerName.contains('inter')) {
      return const Color(0xFFFB090B); // AC Milan Red
    } else {
      return Colors.grey; // Default
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize with existing prediction if available
    _homeScore = widget.initialHomeScore ?? 0;
    _awayScore = widget.initialAwayScore ?? 0;
  }

  void _incrementHomeScore() {
    if (_homeScore < 9) {
      setState(() => _homeScore++);
    }
  }

  void _decrementHomeScore() {
    if (_homeScore > 0) {
      setState(() => _homeScore--);
    }
  }

  void _incrementAwayScore() {
    if (_awayScore < 9) {
      setState(() => _awayScore++);
    }
  }

  void _decrementAwayScore() {
    if (_awayScore > 0) {
      setState(() => _awayScore--);
    }
  }

  void _confirmPrediction() {
    // Return prediction to previous screen
    Navigator.pop(context, {
      'homeScore': _homeScore,
      'awayScore': _awayScore,
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tahmin kaydedildi: $_homeScore - $_awayScore',
          style: GoogleFonts.lexend(),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient Blobs (Fixed, Non-Scrolling)
          _buildBackgroundBlobs(),

          // Main Content — placed in a Positioned.fill SingleChildScrollView so background and bottom bar stay fixed
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Custom AppBar
                  _buildCustomAppBar(),

                  // Match Info Card
                  _buildMatchInfoCard(),

                  // Toggle Tab (Score Prediction / Match Result)
                  _buildToggleTab(),

                  // --- Tab Content: Maç Sonucu (uses API data when available)
                  Builder(
                    builder: (context) {
                      // Determine finished state: prefer explicit flag from parent (widget.isFinished)
                      // otherwise infer from provided initial scores (non-null)
                      final bool isMatchFinished = widget.isFinished ??
                          (widget.initialHomeScore != null && widget.initialAwayScore != null);

                      final int finalHomeScore = widget.initialHomeScore ?? _homeScore;
                      final int finalAwayScore = widget.initialAwayScore ?? _awayScore;

                      if (_selectedTab == 1) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            height: 200,
                            child: Center(
                              child: isMatchFinished
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${finalHomeScore.toString()} - ${finalAwayScore.toString()}',
                                          style: GoogleFonts.lexend(
                                            fontSize: 64,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Maç Sonu',
                                          style: GoogleFonts.lexend(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.sports_soccer,
                                          size: 64,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Maç henüz oynanmadı',
                                          style: GoogleFonts.lexend(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      }

                      // Default: Score Input Area (Skor Tahmini)
                      return _buildScoreInputArea();
                    },
                  ),

                  // Community Stats
                  _buildCommunityStats(),

                  // Social Proof
                  _buildSocialProof(),

                  // Extra bottom spacing (now we include the confirm button as part of the scroll)
                  const SizedBox(height: 8),

                  // Give breathing room before the confirm button
                  const SizedBox(height: 30),

                  // Confirm Prediction button (moved from the sticky Positioned bar to scrollable content)
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E).withOpacity(0.95),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, -10),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          top: false,
                          child: Row(
                            children: [
                              // Selected Score Display
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _homeScore.toString(),
                                      style: GoogleFonts.lexend(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '-',
                                      style: GoogleFonts.lexend(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _awayScore.toString(),
                                      style: GoogleFonts.lexend(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Confirm Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: _confirmPrediction,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Tahmini Onayla',
                                          style: GoogleFonts.lexend(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  // Background Gradient Blobs
  Widget _buildBackgroundBlobs() {
    return Stack(
      children: [
        // Top-Left Blob (Neon Green)
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        // Bottom-Right Blob (Blue)
        Positioned(
          bottom: -150,
          right: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4568DC).withOpacity(0.1),
                  const Color(0xFF4568DC).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Custom AppBar
  Widget _buildCustomAppBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.cardSurface.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // League / Week Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.league,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.week,
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Notification Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsScreen()));
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.cardSurface.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Match Info Card
  Widget _buildMatchInfoCard() {
    final homeColor = getTeamColor(widget.homeTeam);
    final awayColor = getTeamColor(widget.awayTeam);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              homeColor.withOpacity(0.12), // Sol kenar - çok hafif
              Colors.transparent,          // 18% noktası - tamamen şeffaf
              const Color(0xFF1E1E1E),    // Orta - koyu
              Colors.transparent,          // 82% noktası - tamamen şeffaf
              awayColor.withOpacity(0.12), // Sağ kenar - çok hafif
            ],
            stops: const [0.0, 0.18, 0.5, 0.82, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Home Team (minimalist)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Team Logo (smaller)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.homeTeamLogo,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.shield,
                            size: 20,
                            color: AppColors.textSecondary,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Team Name (single line, fitted)
                  Container(
                    width: 88,
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.homeTeam,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // VS and Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.matchTime,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'VS',
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Away Team (minimalist)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Team Logo (smaller)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.awayTeamLogo,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.shield,
                            size: 20,
                            color: AppColors.textSecondary,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Team Name (single line, fitted)
                  Container(
                    width: 88,
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.awayTeam,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
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

  // Toggle Tab (Score Prediction / Match Result)
  Widget _buildToggleTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Score Prediction Tab
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Skor Tahmini',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == 0
                          ? Colors.black
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Match Result Tab
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Maç Sonucu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == 1
                          ? Colors.black
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedBottomNavIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedBottomNavIndex = index;
          });

          // Navigation behavior for quick integration
          if (index == 0) {
            // Go back to root (Home)
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            // Open Groups screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GroupsScreen()),
            );
          } else if (index == 2) {
            // Open Profile -> Tahminler tab
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          } else if (index == 3) {
            // Open Profile
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF00E676) : Colors.white.withOpacity(0.4),
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF00E676) : Colors.white.withOpacity(0.4),
                  fontSize: 8,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Score Input Area
  Widget _buildScoreInputArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Lighter dark grey
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1), // More visible border
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home Score Counter
            _buildScoreCounter(
              score: _homeScore,
              onIncrement: _incrementHomeScore,
              onDecrement: _decrementHomeScore,
              label: 'Ev Sahibi',
            ),

            // VS Divider
            Container(
              width: 1,
              height: 120,
              color: Colors.white.withOpacity(0.1),
            ),

            // Away Score Counter
            _buildScoreCounter(
              score: _awayScore,
              onIncrement: _incrementAwayScore,
              onDecrement: _decrementAwayScore,
              label: 'Deplasman',
            ),
          ],
        ),
      ),
    );
  }

  // Score Counter Widget
  Widget _buildScoreCounter({
    required int score,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required String label,
  }) {
    return Column(
      children: [
        // Label
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Increment Button
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Score Display
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              score.toString(),
              style: GoogleFonts.lexend(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Decrement Button
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  // Community Stats
  Widget _buildCommunityStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Topluluk Tahminleri',
            style: GoogleFonts.lexend(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Progress Bar Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Lighter dark grey
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1), // More visible border
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Stacked Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        // Home Win
                        Expanded(
                          flex: _homeWinPercentage.toInt(),
                          child: Container(
                            color: AppColors.primary,
                          ),
                        ),
                        // Draw
                        Expanded(
                          flex: _drawPercentage.toInt(),
                          child: Container(
                            color: Colors.grey[700],
                          ),
                        ),
                        // Away Win
                        Expanded(
                          flex: _awayWinPercentage.toInt(),
                          child: Container(
                            color: const Color(0xFF4568DC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Percentage Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Home Win %
                    _buildStatLabel(
                      label: widget.homeTeam,
                      percentage: _homeWinPercentage,
                      color: AppColors.primary,
                    ),

                    // Draw %
                    _buildStatLabel(
                      label: 'Beraberlik',
                      percentage: _drawPercentage,
                      color: Colors.grey[700]!,
                    ),

                    // Away Win %
                    _buildStatLabel(
                      label: widget.awayTeam,
                      percentage: _awayWinPercentage,
                      color: const Color(0xFF4568DC),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stat Label Widget
  Widget _buildStatLabel({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${percentage.toInt()}%',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Social Proof
  Widget _buildSocialProof() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Lighter dark grey
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1), // More visible border
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Stacked Avatars
            SizedBox(
              width: 80,
              height: 32,
              child: Stack(
                children: List.generate(4, (index) {
                  return Positioned(
                    left: index * 16.0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1E1E1E), // Match card color
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.6),
                            const Color(0xFF4568DC).withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '4 arkadaşın ',
                      style: GoogleFonts.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'tahmin yaptı',
                      style: GoogleFonts.lexend(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Sticky Bar
  Widget _buildBottomStickyBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95), // Lighter dark grey
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Selected Score Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _homeScore.toString(),
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '-',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _awayScore.toString(),
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Confirm Button
                Expanded(
                  child: GestureDetector(
                    onTap: _confirmPrediction,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tahmini Onayla',
                            style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
