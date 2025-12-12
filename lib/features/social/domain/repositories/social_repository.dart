import '../../data/models/user_entity.dart';
import '../../data/models/league_entity.dart';
import '../../data/models/league_message_entity.dart';
import '../../data/models/duel_entity.dart';
import '../../data/models/power_up_entity.dart';

/// Abstract repository for social features (leagues, leaderboards)
abstract class SocialRepository {
  /// Get all leagues the current user is a member of
  Future<List<LeagueEntity>> getMyLeagues();

  /// Create a new private league
  Future<LeagueEntity> createLeague(String name);

  /// Join a league using invite code
  Future<LeagueEntity> joinLeague(String inviteCode);

  /// Get leaderboard for a specific league
  Future<List<LeagueMember>> getLeagueStandings(String leagueId);

  /// Get global leaderboard
  Future<List<UserEntity>> getGlobalLeaderboard({int limit = 100});

  /// Leave a league
  Future<void> leaveLeague(String leagueId);

  /// Get league details
  Future<LeagueEntity> getLeagueById(String leagueId);

  /// Search for users
  Future<List<UserEntity>> searchUsers(String query);

  // ===== NEW: League Chat/Feed =====
  /// Get messages for a league (chat + system events)
  Future<List<LeagueMessageEntity>> getLeagueMessages(String leagueId, {int limit = 50});

  /// Send a chat message to a league
  Future<void> sendLeagueMessage(String leagueId, String text);

  // ===== NEW: 1v1 Duels =====
  /// Challenge another user to a duel
  Future<DuelEntity> createDuel({
    required String opponentId,
    required String matchId,
    required int stakeAmount,
  });

  /// Get active duels for current user
  Future<List<DuelEntity>> getMyDuels();

  // ===== NEW: Power-Ups (Jokers) =====
  /// Use a power-up on a specific match
  Future<void> usePowerUp({
    required String matchId,
    required PowerUpType powerUpType,
  });

  /// Get power-ups owned by current user
  Future<List<PowerUpEntity>> getMyPowerUps();

  /// Get predictions of other users (using Spy joker)
  Future<Map<String, String>> spyOnPredictions(String matchId);
}

