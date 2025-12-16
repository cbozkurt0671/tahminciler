import 'package:flutter/material.dart';
import 'tournament_model.dart';

class TournamentProvider extends ChangeNotifier {
  List<TournamentMatch> matches = [];

  TournamentProvider() {
    _initializeMatches();
  }

  void _initializeMatches() {
    // Round of 32 (16 matches)
    for (int i = 0; i < 16; i++) {
      matches.add(TournamentMatch(
        id: 'r32_$i',
        roundIndex: 0,
        nextMatchId: 'r16_${i ~/ 2}',
      ));
    }

    // Round of 16 (8 matches)
    for (int i = 0; i < 8; i++) {
      matches.add(TournamentMatch(
        id: 'r16_$i',
        roundIndex: 1,
        nextMatchId: 'qf_${i ~/ 2}',
      ));
    }

    // Quarter Finals (4 matches)
    for (int i = 0; i < 4; i++) {
      matches.add(TournamentMatch(
        id: 'qf_$i',
        roundIndex: 2,
        nextMatchId: 'sf_${i ~/ 2}',
      ));
    }

    // Semi Finals (2 matches)
    for (int i = 0; i < 2; i++) {
      matches.add(TournamentMatch(
        id: 'sf_$i',
        roundIndex: 3,
        nextMatchId: 'final',
      ));
    }

    // Final (1 match)
    matches.add(TournamentMatch(
      id: 'final',
      roundIndex: 4,
    ));
  }

  void advanceWinner(String matchId, String winnerName) {
    final match = matches.firstWhere((m) => m.id == matchId);
    match.winner = winnerName;

    if (match.nextMatchId != null) {
      final nextMatch = matches.firstWhere((m) => m.id == match.nextMatchId);
      if (nextMatch.team1 == null) {
        nextMatch.team1 = winnerName;
      } else if (nextMatch.team2 == null) {
        nextMatch.team2 = winnerName;
      }
    }

    notifyListeners();
  }

  void setAdminMatchTeams(String matchId, String team1, String team2) {
    final match = matches.firstWhere((m) => m.id == matchId);
    match.team1 = team1;
    match.team2 = team2;
    notifyListeners();
  }

  void reset() {
    matches.clear();
    _initializeMatches();
    notifyListeners();
  }
}