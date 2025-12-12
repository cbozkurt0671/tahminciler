import '../../data/models/match_model.dart';
import '../../data/models/group_standing.dart';
import '../../domain/repositories/match_repository.dart';

/// PocketBase implementation of MatchRepository
/// This will connect to our self-hosted PocketBase server
/// 
/// PocketBase Setup Required:
/// 1. Install PocketBase (https://pocketbase.io/)
/// 2. Create collections: matches, predictions, standings, users
/// 3. Set up authentication
/// 4. Configure CORS for Flutter web
/// 
/// Environment Variables:
/// - POCKETBASE_URL: http://localhost:8090 (or your server URL)
/// - POCKETBASE_ADMIN_EMAIL
/// - POCKETBASE_ADMIN_PASSWORD
class PocketBaseMatchRepository implements MatchRepository {
  // TODO: Initialize PocketBase client
  // final PocketBase pb = PocketBase('http://localhost:8090');

  // TODO: Add authentication
  // String? _currentUserId;

  @override
  Future<List<MatchModel>> getMatches() async {
    // TODO: Implement PocketBase query
    // final records = await pb.collection('matches').getFullList();
    // return records.map((record) => MatchModel.fromJson(record.toJson())).toList();
    
    throw UnimplementedError(
      'PocketBase integration not yet implemented. '
      'Switch to MockMatchRepository in service_locator.dart',
    );
  }

  @override
  Future<List<MatchModel>> getMatchesByDay(String dateKey) async {
    // TODO: Implement with PocketBase filter
    // final records = await pb.collection('matches').getList(
    //   filter: 'matchDate = "$dateKey"',
    // );
    
    throw UnimplementedError('PocketBase: getMatchesByDay');
  }

  @override
  Future<List<MatchModel>> getMatchesByGroup(String groupName) async {
    // TODO: Implement with PocketBase filter
    // final records = await pb.collection('matches').getList(
    //   filter: 'group = "$groupName"',
    // );
    
    throw UnimplementedError('PocketBase: getMatchesByGroup');
  }

  @override
  Future<List<MatchModel>> getHeroMatches() async {
    // TODO: Implement with PocketBase filter
    // final records = await pb.collection('matches').getList(
    //   filter: 'isHero = true',
    // );
    
    throw UnimplementedError('PocketBase: getHeroMatches');
  }

  @override
  Future<void> savePrediction({
    required String matchId,
    required int homeScore,
    required int awayScore,
  }) async {
    // TODO: Save to PocketBase
    // await pb.collection('predictions').create(body: {
    //   'userId': _currentUserId,
    //   'matchId': matchId,
    //   'homeScore': homeScore,
    //   'awayScore': awayScore,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
    
    throw UnimplementedError('PocketBase: savePrediction');
  }

  @override
  Future<void> saveExtraPrediction({
    required String matchId,
    required String questionId,
    required bool answer,
  }) async {
    // TODO: Save extra prediction to PocketBase
    // await pb.collection('extra_predictions').create(body: {
    //   'userId': _currentUserId,
    //   'matchId': matchId,
    //   'questionId': questionId,
    //   'answer': answer,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
    
    throw UnimplementedError('PocketBase: saveExtraPrediction');
  }

  @override
  Future<List<GroupStanding>> getStandings(String groupName) async {
    // TODO: Fetch from PocketBase
    // final records = await pb.collection('standings').getList(
    //   filter: 'groupName = "$groupName"',
    //   sort: '-points',
    // );
    
    throw UnimplementedError('PocketBase: getStandings');
  }

  @override
  Future<void> toggleFavorite(String matchId, bool isFavorite) async {
    // TODO: Update user's favorites in PocketBase
    // await pb.collection('user_favorites').create(body: {
    //   'userId': _currentUserId,
    //   'matchId': matchId,
    //   'isFavorite': isFavorite,
    // });
    
    throw UnimplementedError('PocketBase: toggleFavorite');
  }

  @override
  Future<Map<String, dynamic>> getUserPredictions(String userId) async {
    // TODO: Fetch all user predictions from PocketBase
    // final records = await pb.collection('predictions').getFullList(
    //   filter: 'userId = "$userId"',
    // );
    
    throw UnimplementedError('PocketBase: getUserPredictions');
  }

  @override
  Future<int> calculateUserScore(String userId) async {
    // TODO: Calculate score based on correct predictions
    // This could be done server-side with PocketBase functions
    
    throw UnimplementedError('PocketBase: calculateUserScore');
  }
}

/* 
 * POCKETBASE SCHEMA EXAMPLE:
 * 
 * Collection: matches
 * Fields:
 * - id (text, primary)
 * - homeTeam (text)
 * - awayTeam (text)
 * - homeFlagUrl (url)
 * - awayFlagUrl (url)
 * - matchTime (text)
 * - matchDate (date)
 * - city (text)
 * - stadium (text)
 * - group (text)
 * - homeScore (number, optional)
 * - awayScore (number, optional)
 * - isLive (bool)
 * - isHero (bool)
 * - questions (json)
 * 
 * Collection: predictions
 * Fields:
 * - id (text, primary)
 * - userId (relation to users)
 * - matchId (relation to matches)
 * - homeScore (number)
 * - awayScore (number)
 * - timestamp (date)
 * 
 * Collection: extra_predictions
 * Fields:
 * - id (text, primary)
 * - userId (relation to users)
 * - matchId (relation to matches)
 * - questionId (text)
 * - answer (bool)
 * - timestamp (date)
 * 
 * Collection: standings
 * Fields:
 * - id (text, primary)
 * - groupName (text)
 * - teamName (text)
 * - flagUrl (url)
 * - played (number)
 * - won (number)
 * - drawn (number)
 * - lost (number)
 * - goalsFor (number)
 * - goalsAgainst (number)
 * - points (number)
 */
