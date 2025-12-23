import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_loader.dart';
import '../../data/models/match_model.dart';

/// Simplified, valid implementation of QuickPredictCard to fix parser errors.
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Home
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          CachedTeamLogoWidget(
                            teamId: widget.match.homeTeamId ?? 0,
                            size: 30,
                            fit: BoxFit.contain,
                            fallbackIconColor: AppColors.textSecondary
                                .withOpacity(0.5),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.match.homeTeam,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scores
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ScoreInput(
                            controller: _homeScoreController,
                            focusNode: _homeFocusNode,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '-',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          _ScoreInput(
                            controller: _awayScoreController,
                            focusNode: _awayFocusNode,
                          ),
                        ],
                      ),
                    ),

                    // Away
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              widget.match.awayTeam,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CachedTeamLogoWidget(
                            teamId: widget.match.awayTeamId ?? 0,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  '${widget.match.matchDate} • ${widget.match.matchTime}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
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

class _ScoreInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _ScoreInput({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: focusNode.hasFocus ? Colors.white70 : Colors.white24,
          width: focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
