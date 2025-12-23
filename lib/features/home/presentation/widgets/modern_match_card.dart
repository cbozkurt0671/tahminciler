import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/prediction_question.dart';
import '../screens/prediction_screen.dart';

class ModernMatchCard extends StatefulWidget {
  final String leagueName;
  final String leagueIcon;
  final String homeTeam;
  final String awayTeam;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final String matchTime;
  final String matchDate;
  final bool isLive;
  final String? liveMinute;
  final int? homeScore;
  final int? awayScore;
  final bool isUpcoming;
  final VoidCallback? onScoreSubmit;
  final List<PredictionQuestion>? questions;
  final int? userPredictedHomeScore;
  final int? userPredictedAwayScore;
  final Function(int homeScore, int awayScore)? onPredictionUpdated;

  const ModernMatchCard({
    super.key,
    required this.leagueName,
    required this.leagueIcon,
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamLogo,
    this.awayTeamLogo,
    required this.matchTime,
    required this.matchDate,
    this.isLive = false,
    this.liveMinute,
    this.homeScore,
    this.awayScore,
    this.isUpcoming = true,
    this.onScoreSubmit,
    this.questions,
    this.userPredictedHomeScore,
    this.userPredictedAwayScore,
    this.onPredictionUpdated,
  });

  @override
  State<ModernMatchCard> createState() => _ModernMatchCardState();
}

class _ModernMatchCardState extends State<ModernMatchCard>
    with SingleTickerProviderStateMixin {
  final _homeScoreController = TextEditingController();
  final _awayScoreController = TextEditingController();
  bool _isExpanded = false;
  final Map<String, String> _selectedAnswers = {}; // questionId -> answer
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Behavior to allow child widgets to receive taps
      behavior: HitTestBehavior.opaque,
      
      // Tap: Navigate to PredictionScreen
      onTap: () async {
        final result = await Navigator.push<Map<String, int>>(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionScreen(
              homeTeam: widget.homeTeam,
              awayTeam: widget.awayTeam,
              homeTeamLogo: widget.homeTeamLogo ?? '',
              awayTeamLogo: widget.awayTeamLogo ?? '',
              league: widget.leagueName,
              week: widget.matchDate,
              matchTime: widget.matchTime,
              initialHomeScore: widget.userPredictedHomeScore,
              initialAwayScore: widget.userPredictedAwayScore,
            ),
          ),
        );
        
        // If prediction was updated, notify parent
        if (result != null && widget.onPredictionUpdated != null) {
          widget.onPredictionUpdated!(
            result['homeScore']!,
            result['awayScore']!,
          );
        }
      },
      
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Lighter dark grey for better contrast
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1), // More visible border
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Team Color Gradients (Behind content)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    // Home Team Gradient (Left to Center)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              getTeamColor(widget.homeTeam).withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Away Team Gradient (Center to Right)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              getTeamColor(widget.awayTeam).withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main Content (On top of gradients)
            Column(
              children: [
                // Header + Live Badge
                _buildHeader(),

                // Match Info Body
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Time & Date
                      _buildTimeSection(),

                      const SizedBox(width: 12), // Reduced spacing

                      // Center: Teams (take available space, keep natural height)
                      Expanded(
                        child: _buildTeamsSection(),
                      ),

                      const SizedBox(width: 12), // Reduced spacing

                      // Right: Score Input/Display — center this column vertically without constraining teams
                      Center(
                        child: _buildScoreSection(),
                      ),
                    ],
                  ),
                ),

                // Expandable Gamification Section
                _buildGamificationSection(),
              ],
            ),
          ],
        ), // End of Stack
      ), // End of Container
    ); // End of GestureDetector
  }

  // Header with League Info
  Widget _buildHeader() {
    // If both league name and icon are empty, don't render a header
    if ((widget.leagueName.trim().isEmpty) && (widget.leagueIcon.trim().isEmpty)) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // League Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              // League Icon
              if (widget.leagueIcon.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    widget.leagueIcon,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.emoji_events_rounded,
                        size: 18,
                        color: AppColors.primary.withOpacity(0.8),
                      );
                    },
                  ),
                )
              else
                Icon(
                  Icons.emoji_events_rounded,
                  size: 18,
                  color: AppColors.primary.withOpacity(0.8),
                ),

              const SizedBox(width: 8),

              // League Name
              Text(
                widget.leagueName,
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Time Section
  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time
        Text(
          widget.matchTime,
          style: GoogleFonts.lexend(
            fontSize: 15, // Reduced from 18
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3), // Reduced from 4
        // Date Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.matchDate,
            style: GoogleFonts.lexend(
              fontSize: 9, // Reduced from 10
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // Teams Section
  Widget _buildTeamsSection() {
    return Column(
      children: [
        // Home Team
        _buildTeam(
          teamName: widget.homeTeam,
          teamLogo: widget.homeTeamLogo,
          isHome: true,
        ),
        const SizedBox(height: 12),
        // VS Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'VS',
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Away Team
        _buildTeam(
          teamName: widget.awayTeam,
          teamLogo: widget.awayTeamLogo,
          isHome: false,
        ),
      ],
    );
  }

  // Single Team Row
  Widget _buildTeam({
    required String teamName,
    String? teamLogo,
    required bool isHome,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Team Logo
        if (teamLogo != null && teamLogo.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(6), // Reduced from 8
            child: Image.asset(
              teamLogo,
              width: 24, // Reduced from 32
              height: 24, // Reduced from 32
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 24, // Reduced from 32
                  height: 24, // Reduced from 32
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6), // Reduced from 8
                  ),
                  child: Icon(
                    Icons.shield,
                    size: 14, // Reduced from 18
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          )
        else
          Container(
            width: 24, // Reduced from 32
            height: 24, // Reduced from 32
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6), // Reduced from 8
            ),
            child: Icon(
              Icons.shield,
              size: 14, // Reduced from 18
              color: AppColors.textSecondary,
            ),
          ),

        const SizedBox(width: 8), // Reduced from 10

        // Team Name
        Expanded(
          child: Text(
            teamName,
            style: GoogleFonts.lexend(
              fontSize: 13, // Reduced from 14
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Score Section (Input or Display)
  Widget _buildScoreSection() {
    if (widget.isLive || !widget.isUpcoming) {
      // Display Live/Final Score
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildScoreDisplay(widget.homeScore ?? 0),
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          _buildScoreDisplay(widget.awayScore ?? 0),
        ],
      );
    } else {
      // Show user prediction if available, otherwise show input
      if (widget.userPredictedHomeScore != null && widget.userPredictedAwayScore != null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPredictionDisplay(widget.userPredictedHomeScore!),
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 12),
            _buildPredictionDisplay(widget.userPredictedAwayScore!),
            const SizedBox(height: 8),
            // Small indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Tahmin',
                style: GoogleFonts.lexend(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      } else {
        // Input for Predictions
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScoreInput(_homeScoreController),
            const SizedBox(height: 8), // Reduced from 12
            Container(
              width: 30, // Reduced from 40
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 8), // Reduced from 12
            _buildScoreInput(_awayScoreController),
          ],
        );
      }
    }
  }

  // User Prediction Display
  Widget _buildPredictionDisplay(int score) {
    return Container(
      width: 40, // Reduced from 50
      height: 40, // Reduced from 50
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10), // Reduced from 12
        border: Border.all(
          color: AppColors.primary.withOpacity(0.5),
          width: 1.5, // Reduced from 2
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15), // Reduced opacity
            blurRadius: 6, // Reduced from 8
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          score.toString(),
          style: GoogleFonts.lexend(
            fontSize: 18, // Reduced from 22
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // Score Display (Live/Final)
  Widget _buildScoreDisplay(int score) {
    return Container(
      width: 40, // Reduced from 50
      height: 40, // Reduced from 50
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10), // Reduced from 12
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5, // Reduced from 2
        ),
      ),
      child: Center(
        child: Text(
          score.toString(),
          style: GoogleFonts.lexend(
            fontSize: 20, // Reduced from 24
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // Score Input Field
  Widget _buildScoreInput(TextEditingController controller) {
    return Container(
      width: 45,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 2,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        cursorColor: const Color(0xFF0DF259),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          counterText: '',
        ),
      ),
    );
  }

  // Expandable Gamification Section
  Widget _buildGamificationSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 20,
                color: Colors.amber[400],
              ),
              const SizedBox(width: 8),
              Text(
                'Risk al, puanları kap!',
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+150 Puan',
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber[400],
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildQuestionsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build questions list dynamically
  List<Widget> _buildQuestionsList() {
    if (widget.questions == null || widget.questions!.isEmpty) {
      // Default question if no questions provided
      return [
        Text(
          'İlk golü kim atar?',
          style: GoogleFonts.lexend(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPredictionOption(
                questionId: 'default',
                label: widget.homeTeam.split(' ').first,
                value: 'home',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPredictionOption(
                questionId: 'default',
                label: 'Yok',
                value: 'none',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPredictionOption(
                questionId: 'default',
                label: widget.awayTeam.split(' ').first,
                value: 'away',
              ),
            ),
          ],
        ),
      ];
    }

    // Build questions from match data
    final questionWidgets = <Widget>[];
    for (var i = 0; i < widget.questions!.length; i++) {
      final question = widget.questions![i];
      
      if (i > 0) {
        questionWidgets.add(const SizedBox(height: 16));
      }
      
      // Question text
      questionWidgets.add(
        Text(
          question.text,
          style: GoogleFonts.lexend(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
      
      questionWidgets.add(const SizedBox(height: 12));
      
      // Yes/No answer options
      questionWidgets.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildPredictionOption(
                  questionId: question.id,
                  label: 'Evet (+${question.yesPoints})',
                  value: 'yes',
                ),
              ),
            ),
            Expanded(
              child: _buildPredictionOption(
                questionId: question.id,
                label: 'Hayır (+${question.noPoints})',
                value: 'no',
              ),
            ),
          ],
        ),
      );
    }
    
    return questionWidgets;
  }

  // Prediction Option Button
  Widget _buildPredictionOption({
    required String questionId,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedAnswers[questionId] == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle: if already selected, remove the answer; otherwise set it
          if (_selectedAnswers[questionId] == value) {
            _selectedAnswers.remove(questionId);
          } else {
            _selectedAnswers[questionId] = value;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.background
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
