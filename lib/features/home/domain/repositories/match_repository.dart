import '../../data/models/match_model.dart';
import '../../data/models/group_standing.dart';

/// Abstract repository interface for match data
/// This allows us to swap between different data sources (Mock, PocketBase, Firebase, etc.)
/// without changing any UI code
abstract class MatchRepository {
  /// Get all matches
  Future<List<MatchModel>> getMatches();

  /// Get matches for a specific day
  /// [dateKey] format: "2026-06-12"
  Future<List<MatchModel>> getMatchesByDay(String dateKey);

  /// Get matches for a specific group
  /// [groupName] format: "A Grubu", "B Grubu", etc.
  Future<List<MatchModel>> getMatchesByGroup(String groupName);

  /// Get hero matches (featured matches)
  Future<List<MatchModel>> getHeroMatches();

  /// Save score prediction for a match
  Future<void> savePrediction({
    required String matchId,
    required int homeScore,
    required int awayScore,
  });

  /// Save extra prediction (prop bet) for a match
  Future<void> saveExtraPrediction({
    required String matchId,
    required String questionId,
    required bool answer,
  });

  /// Get group standings
  Future<List<GroupStanding>> getStandings(String groupName);

  /// Toggle favorite status for a match
  Future<void> toggleFavorite(String matchId, bool isFavorite);

  /// Get user's predictions
  Future<Map<String, dynamic>> getUserPredictions(String userId);

  /// Calculate user's total score
  Future<int> calculateUserScore(String userId);
}
