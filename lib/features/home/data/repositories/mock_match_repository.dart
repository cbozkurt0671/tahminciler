import '../../data/models/match_model.dart';
import '../../data/models/group_standing.dart';
import '../../data/dummy_data.dart';
import '../../domain/repositories/match_repository.dart';

/// Mock implementation of MatchRepository
/// Uses local dummy data for development
/// This will be replaced with PocketBaseMatchRepository in production
class MockMatchRepository implements MatchRepository {
  // In-memory storage for predictions (simulates database)
  final Map<String, Map<String, dynamic>> _predictions = {};
  final Map<String, bool> _favorites = {};

  @override
  Future<List<MatchModel>> getMatches() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return DummyMatchData.getMatches();
  }

  @override
  Future<List<MatchModel>> getMatchesByDay(String dateKey) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final allMatches = DummyMatchData.getMatches();
    return allMatches.where((match) => match.matchDate == dateKey).toList();
  }

  @override
  Future<List<MatchModel>> getMatchesByGroup(String groupName) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final allMatches = DummyMatchData.getMatches();
    return allMatches.where((match) => match.group == groupName).toList();
  }

  @override
  Future<List<MatchModel>> getHeroMatches() async {
    await Future.delayed(const Duration(milliseconds: 50));
    final allMatches = DummyMatchData.getMatches();
    return allMatches.where((match) => match.isHero).toList();
  }

  @override
  Future<void> savePrediction({
    required String matchId,
    required int homeScore,
    required int awayScore,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    // Save to in-memory storage
    _predictions[matchId] = {
      'homeScore': homeScore,
      'awayScore': awayScore,
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('✅ Mock: Saved prediction for $matchId: $homeScore-$awayScore');
  }

  @override
  Future<void> saveExtraPrediction({
    required String matchId,
    required String questionId,
    required bool answer,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Initialize match predictions if not exists
    _predictions[matchId] ??= {};

    // Save extra prediction
    _predictions[matchId]![questionId] = answer;

    print('✅ Mock: Saved extra prediction for $matchId ($questionId): $answer');
  }

  @override
  Future<List<GroupStanding>> getStandings(String groupName) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return DummyMatchData.getStandingsForGroup(groupName);
  }

  @override
  Future<void> toggleFavorite(String matchId, bool isFavorite) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _favorites[matchId] = isFavorite;
    print('✅ Mock: Toggled favorite for $matchId: $isFavorite');
  }

  @override
  Future<Map<String, dynamic>> getUserPredictions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In mock mode, return stored predictions
    return Map<String, dynamic>.from(_predictions);
  }

  @override
  Future<int> calculateUserScore(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Mock calculation
    int totalScore = 0;

    // Calculate score based on predictions
    _predictions.forEach((matchId, predictions) {
      // Score prediction points
      if (predictions.containsKey('homeScore') &&
          predictions.containsKey('awayScore')) {
        totalScore += 100; // Base points for score prediction
      }

      // Extra prediction points
      predictions.forEach((key, value) {
        if (key != 'homeScore' &&
            key != 'awayScore' &&
            key != 'timestamp' &&
            value is bool) {
          totalScore += 15; // Points per extra prediction
        }
      });
    });

    return totalScore;
  }

  /// Helper method to clear all predictions (for testing)
  void clearAllPredictions() {
    _predictions.clear();
    _favorites.clear();
    print('🗑️ Mock: Cleared all predictions');
  }

  /// Get current stored predictions (for debugging)
  Map<String, Map<String, dynamic>> getStoredPredictions() {
    return Map<String, Map<String, dynamic>>.from(_predictions);
  }
}
