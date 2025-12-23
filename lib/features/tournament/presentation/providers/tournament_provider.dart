import 'package:flutter/material.dart';
import 'package:world_cup_app/models/match.dart';

class TournamentProvider extends ChangeNotifier {
  List<Match> matches = [];

  TournamentProvider() {
    _initializeMatches();
  }

  void _initializeMatches() {
    // Sample teams
    final teams = [
      Team(id: 't1', name: 'Brazil', logoUrl: 'https://example.com/brazil.png'),
      Team(id: 't2', name: 'Argentina', logoUrl: 'https://example.com/argentina.png'),
      Team(id: 't3', name: 'France', logoUrl: 'https://example.com/france.png'),
      Team(id: 't4', name: 'Germany', logoUrl: 'https://example.com/germany.png'),
      Team(id: 't5', name: 'Spain', logoUrl: 'https://example.com/spain.png'),
      Team(id: 't6', name: 'England', logoUrl: 'https://example.com/england.png'),
      Team(id: 't7', name: 'Portugal', logoUrl: 'https://example.com/portugal.png'),
      Team(id: 't8', name: 'Netherlands', logoUrl: 'https://example.com/netherlands.png'),
      Team(id: 't9', name: 'Uruguay', logoUrl: 'https://example.com/uruguay.png'),
      Team(id: 't10', name: 'Colombia', logoUrl: 'https://example.com/colombia.png'),
      Team(id: 't11', name: 'Mexico', logoUrl: 'https://example.com/mexico.png'),
      Team(id: 't12', name: 'USA', logoUrl: 'https://example.com/usa.png'),
      Team(id: 't13', name: 'Japan', logoUrl: 'https://example.com/japan.png'),
      Team(id: 't14', name: 'South Korea', logoUrl: 'https://example.com/southkorea.png'),
      Team(id: 't15', name: 'Senegal', logoUrl: 'https://example.com/senegal.png'),
      Team(id: 't16', name: 'Morocco', logoUrl: 'https://example.com/morocco.png'),
    ];

    // Round of 16 (8 matches)
    for (int i = 0; i < 8; i++) {
      matches.add(Match(
        id: 'r16_$i',
        roundIndex: 0,
        team1: teams[i * 2],
        team2: teams[i * 2 + 1],
        nextMatchId: 'qf_${i ~/ 2}',
      ));
    }

    // Quarter Finals (4 matches)
    for (int i = 0; i < 4; i++) {
      matches.add(Match(
        id: 'qf_$i',
        roundIndex: 1,
        nextMatchId: 'sf_${i ~/ 2}',
      ));
    }

    // Semi Finals (2 matches)
    for (int i = 0; i < 2; i++) {
      matches.add(Match(
        id: 'sf_$i',
        roundIndex: 2,
        nextMatchId: 'final',
      ));
    }

    // Final (1 match)
    matches.add(Match(
      id: 'final',
      roundIndex: 3,
    ));
  }

  void selectWinner(Match match, Team winner) {
    match.winner = winner;

    // Propagate to next match
    if (match.nextMatchId != null) {
      final nextMatch = matches.firstWhere((m) => m.id == match.nextMatchId);
      if (nextMatch.team1 == null) {
        nextMatch.team1 = winner;
      } else {
        nextMatch.team2 ??= winner;
      }
    }

    notifyListeners();
  }

  void reset() {
    matches.clear();
    _initializeMatches();
    notifyListeners();
  }
}