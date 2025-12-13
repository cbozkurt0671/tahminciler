import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_loader.dart';
import '../../data/models/match_model.dart';

/// Card widget for quick match prediction
/// Allows users to input scores directly
class QuickPredictCard extends StatefulWidget {
  final MatchModel match;
  final Function(int homeScore, int awayScore)? onPredictionChanged;
  final VoidCallback? onCardTap;

  const QuickPredictCard({
    super.key,
    required this.match,
    this.onPredictionChanged,
    this.onCardTap,
  });

  @override
  State<QuickPredictCard> createState() => _QuickPredictCardState();
}

class _QuickPredictCardState extends State<QuickPredictCard> {
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();
  final FocusNode _homeFocusNode = FocusNode();
  final FocusNode _awayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.match.homeScore != null) {
      _homeScoreController.text = widget.match.homeScore.toString();
    }
    if (widget.match.awayScore != null) {
      _awayScoreController.text = widget.match.awayScore.toString();
    }

    _homeScoreController.addListener(_onScoreChanged);
    _awayScoreController.addListener(_onScoreChanged);
  }

  void _onScoreChanged() {
    final homeScore = int.tryParse(_homeScoreController.text);
    final awayScore = int.tryParse(_awayScoreController.text);
    
    if (homeScore != null && awayScore != null) {
      widget.onPredictionChanged?.call(homeScore, awayScore);
    }
  }

  @override
  void dispose() {
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    _homeFocusNode.dispose();
    _awayFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onCardTap,
          borderRadius: BorderRadius.circular(AppColors.cardRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // Main row with teams and score inputs
                Row(
                  children: [
                    // Home Team
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          CachedTeamLogoWidget(
                            teamId: widget.match.homeTeamId ?? 0,
                            size: 30,
                            fit: BoxFit.contain,
                            fallbackIconColor: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.match.homeTeam,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Score Input Area
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Home Score Input
                          _ScoreInput(
                            controller: _homeScoreController,
                            focusNode: _homeFocusNode,
                          ),
                          
                          // Dash separator
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '-',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                            ),
                          ),
                          
                          // Away Score Input
                          _ScoreInput(
                            controller: _awayScoreController,
                            focusNode: _awayFocusNode,
                          ),
                        ],
                      ),
                    ),
                    
                    // Away Team
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              widget.match.awayTeam,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CachedTeamLogoWidget(
                            teamId: widget.match.awayTeamId ?? 0,
                            size: 30,
                            fit: BoxFit.contain,
                            fallbackIconColor: AppColors.textSecondary.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Match time and date
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.match.matchDate} • ${widget.match.matchTime}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 12,
                      ),
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
}

/// Score input field widget
class _ScoreInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _ScoreInput({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF121219),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: focusNode.hasFocus 
              ? AppColors.gradientBlue 
              : AppColors.textSecondary.withOpacity(0.2),
          width: focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
