import 'package:flutter/material.dart';
import '../../data/models/match_model.dart';
import 'quick_predict_card.dart';

/// Scrollable list of matches for quick predictions
class QuickPredictList extends StatelessWidget {
  final List<MatchModel> matches;
  final Function(MatchModel match, int homeScore, int awayScore)? onPredictionChanged;
  final Function(MatchModel match)? onMatchTap;

  const QuickPredictList({
    super.key,
    required this.matches,
    this.onPredictionChanged,
    this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return QuickPredictCard(
          match: match,
          onPredictionChanged: (homeScore, awayScore) {
            onPredictionChanged?.call(match, homeScore, awayScore);
          },
          onCardTap: () {
            onMatchTap?.call(match);
          },
        );
      },
    );
  }
}
