import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../domain/repositories/match_repository.dart';
import '../models/match_model.dart';
import '../models/group_standing.dart';
import '../models/prediction_question.dart';

/// SofaScore API Repository with Retry Mechanism
/// Fetches real-time football match data from SofaScore API
/// Implements stubborn retry logic to handle 403 errors
class SofaScoreRepository implements MatchRepository {
  /// Current selected date for fetching matches
  DateTime _selectedDate = DateTime.now();
  
  /// Get current selected date
  DateTime get selectedDate => _selectedDate;
  
  /// Build dynamic API URL based on selected date
  String get _apiUrl {
    final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    return 'http://www.sofascore.com/api/v1/sport/football/scheduled-events/$dateStr';
  }
  
  /// Set the date to fetch matches for
  @override
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    clearCache(); // Clear cache when date changes
  }

  /// Retry configuration
  static const int _maxRetries = 5;
  static const int _delaySeconds = 2;

  /// Required headers for SofaScore API - Real browser headers
  static const Map<String, String> _headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.9,tr;q=0.8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Referer': 'http://www.sofascore.com/',
    'Origin': 'http://www.sofascore.com',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'Cache-Control': 'no-cache',
    'Pragma': 'no-cache',
  };

  /// Cache for fetched matches
  List<MatchModel>? _cachedMatches;

  /// Flag to track if we're currently fetching
  bool _isFetching = false;

  /// Stubborn fetch with retry mechanism
  /// Retries up to _maxRetries times with _delaySeconds between attempts
  Future<Map<String, dynamic>?> _fetchWithRetry() async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        print('🔄 SofaScore Fetch Attempt $attempt/$_maxRetries...');
        
        final response = await http.get(
          Uri.parse(_apiUrl),
          headers: _headers,
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          print('✅ SUCCESS on attempt $attempt! Status: 200');
          final data = json.decode(response.body);
          return data;
        } else {
          print('⚠️ Attempt $attempt failed with status: ${response.statusCode}');
          print('Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
          
          if (attempt < _maxRetries) {
            print('⏳ Waiting $_delaySeconds seconds before retry...');
            await Future.delayed(Duration(seconds: _delaySeconds));
          }
        }
      } catch (e) {
        print('❌ Attempt $attempt failed with exception: $e');
        
        if (attempt < _maxRetries) {
          print('⏳ Waiting $_delaySeconds seconds before retry...');
          await Future.delayed(Duration(seconds: _delaySeconds));
        }
      }
    }

    print('💔 All $_maxRetries attempts failed. Giving up.');
    return null;
  }

  @override
  Future<List<MatchModel>> getMatches() async {
    // Return cached data if available
    if (_cachedMatches != null) {
      print('📦 Returning cached data: ${_cachedMatches!.length} matches');
      return _cachedMatches!;
    }

    // Prevent multiple simultaneous fetches
    if (_isFetching) {
      print('⏳ Already fetching... waiting...');
      await Future.delayed(const Duration(milliseconds: 500));
      return _cachedMatches ?? [];
    }

    _isFetching = true;

    try {
      print('🌐 Fetching matches from SofaScore API with retry mechanism...');
      
      // Use retry mechanism
      final data = await _fetchWithRetry();

      if (data == null) {
        print('⚠️ Failed to fetch data after all retries');
        _cachedMatches = [];
        _isFetching = false;
        return [];
      }

      final events = data['events'] as List<dynamic>?;

      if (events == null || events.isEmpty) {
        print('⚠️ No events found in API response');
        _cachedMatches = [];
        _isFetching = false;
        return [];
      }

      print('📊 Total events received: ${events.length}');

      // Get selected date's range for filtering
      final selectedDayStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final selectedDayEnd = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);

      // Use Map to prevent duplicates (keyed by match ID)
      final matchesMap = <String, MatchModel>{};
      int skippedByLeague = 0;
      
      for (final event in events) {
        try {
          // Extract match ID first to check duplicates
          final eventId = event['id'].toString();
          
          // Skip if already processed
          if (matchesMap.containsKey(eventId)) {
            continue;
          }

          // Check if match is on selected date
          final startTimestamp = event['startTimestamp'] as int? ?? 0;
          final matchDateTime = DateTime.fromMillisecondsSinceEpoch(startTimestamp * 1000);
          
          // Filter: only include matches happening on selected date
          if (matchDateTime.isBefore(selectedDayStart) || matchDateTime.isAfter(selectedDayEnd)) {
            continue;
          }

          // Extract tournament and category (country) info
          final tournament = event['tournament'];
          if (tournament == null) continue;
          
          final category = tournament['category'];
          if (category == null) continue;
          
          final tName = (tournament['name'] as String?)?.toLowerCase() ?? '';
          final cName = (category['name'] as String?)?.toLowerCase() ?? '';
          
          // Get unique tournament info for stricter filtering
          final uniqueTournament = tournament['uniqueTournament'];
          final slug = (uniqueTournament?['slug'] as String?)?.toLowerCase() ?? '';
          final tournamentId = uniqueTournament?['id'] as int? ?? 0;
          
          // Very strict filtering: Tournament Name + Country + uniqueTournament ID/slug
          String? detectedLeague;
          
          // Premier League: slug = "premier-league", ID = 17
          if ((tName == 'premier league' || slug == 'premier-league' || tournamentId == 17) && cName == 'england') {
            detectedLeague = 'Premier League';
          } 
          // Süper Lig: slug = "super-lig", ID = 52
          else if ((tName.contains('super lig') || slug == 'super-lig' || tournamentId == 52) && cName == 'turkey') {
            detectedLeague = 'Süper Lig';
          } 
          // Bundesliga: slug = "bundesliga", ID = 35
          else if ((tName == 'bundesliga' || slug == 'bundesliga' || tournamentId == 35) && cName == 'germany') {
            detectedLeague = 'Bundesliga';
          } 
          // Serie A: EXACT match only - ID = 23, slug = "serie-a"
          // Exclude Serie B (53), Serie A Femminile (10640), Serie C, etc.
          else if (tournamentId == 23 && slug == 'serie-a' && cName == 'italy') {
            detectedLeague = 'Serie A';
          }
          
          // Only process matches from our target leagues
          if (detectedLeague != null) {
            final match = _mapEventToMatchModel(event, detectedLeague);
            matchesMap[eventId] = match; // Store with ID as key
          } else {
            skippedByLeague++;
          }
        } catch (e) {
          print('⚠️ Error parsing event: $e');
          continue;
        }
      }

      // Convert map values to list
      final matches = matchesMap.values.toList();

      final dateStr = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      print('✅ Found ${matches.length} matches for $dateStr ($skippedByLeague matches from other leagues filtered out)');
      
      if (matches.isEmpty) {
        print('ℹ️ No matches found for target leagues (Premier League, Süper Lig, Bundesliga, Serie A)');
      } else {
        // Log match details
        for (final match in matches) {
          print('   🏟️ ${match.group}: ${match.homeTeam} vs ${match.awayTeam} at ${match.matchTime}');
        }
        
        // ⭐ Select 3-5 random hero matches from different leagues
        final heroMatches = _selectHeroMatches(matches);
        print('⭐ Marked ${heroMatches.length} matches as heroes from different leagues');
        
        // Update matches list with hero flags
        for (int i = 0; i < matches.length; i++) {
          if (heroMatches.any((hero) => hero.id == matches[i].id)) {
            matches[i] = MatchModel(
              id: matches[i].id,
              homeTeam: matches[i].homeTeam,
              awayTeam: matches[i].awayTeam,
              homeTeamId: matches[i].homeTeamId,
              awayTeamId: matches[i].awayTeamId,
              homeFlagUrl: matches[i].homeFlagUrl,
              awayFlagUrl: matches[i].awayFlagUrl,
              matchTime: matches[i].matchTime,
              matchDate: matches[i].matchDate,
              city: matches[i].city,
              stadium: matches[i].stadium,
              group: matches[i].group,
              category: matches[i].category,
              homeScore: matches[i].homeScore,
              awayScore: matches[i].awayScore,
              isLive: matches[i].isLive,
              liveMatchTime: matches[i].liveMatchTime,
              status: matches[i].status, // ✅ Keep status!
              isHero: true, // ⭐ Mark as hero!
              isFavorite: matches[i].isFavorite,
              questions: matches[i].questions,
            );
            print('   ⭐ ${matches[i].homeTeam} vs ${matches[i].awayTeam} (${matches[i].group})');
          }
        }
      }

      _cachedMatches = matches;
      _isFetching = false;
      return matches;

    } catch (e) {
      print('❌ Unexpected error in getMatches: $e');
      _cachedMatches = [];
      _isFetching = false;
      return [];
    }
  }

  /// Select 3-5 hero matches from different leagues
  List<MatchModel> _selectHeroMatches(List<MatchModel> matches) {
    if (matches.isEmpty) return [];
    
    // Group matches by league
    final Map<String, List<MatchModel>> matchesByLeague = {};
    for (final match in matches) {
      if (!matchesByLeague.containsKey(match.group)) {
        matchesByLeague[match.group] = [];
      }
      matchesByLeague[match.group]!.add(match);
    }
    
    // Prioritize live matches first
    final liveMatches = matches.where((m) => m.isLive).toList();
    if (liveMatches.isNotEmpty) {
      return liveMatches.take(5).toList();
    }
    
    // Select one match from each league (up to 5 leagues)
    final selectedMatches = <MatchModel>[];
    final leagues = matchesByLeague.keys.toList();
    
    for (final league in leagues.take(min(5, leagues.length))) {
      final leagueMatches = matchesByLeague[league]!;
      if (leagueMatches.isNotEmpty) {
        // Take first match from each league
        selectedMatches.add(leagueMatches.first);
      }
    }
    
    // Ensure at least 3 matches
    if (selectedMatches.length < 3 && matches.length >= 3) {
      final remaining = matches.where((m) => !selectedMatches.contains(m)).toList();
      while (selectedMatches.length < 3 && remaining.isNotEmpty) {
        selectedMatches.add(remaining.removeAt(0));
      }
    }
    
    return selectedMatches;
  }

  /// Map SofaScore event JSON to MatchModel
  MatchModel _mapEventToMatchModel(Map<String, dynamic> event, String leagueName) {
    // Extract basic info
    final id = event['id'].toString();
    final homeTeam = event['homeTeam']?['name'] as String? ?? 'Unknown';
    final awayTeam = event['awayTeam']?['name'] as String? ?? 'Unknown';
    final homeTeamId = event['homeTeam']?['id'] as int? ?? 0;
    final awayTeamId = event['awayTeam']?['id'] as int? ?? 0;
    
    // Construct logo URLs using .com domain (requires browser headers in UI)
    // Format: https://api.sofascore.com/api/v1/team/{teamId}/image
    final homeFlagUrl = 'https://api.sofascore.com/api/v1/team/$homeTeamId/image';
    final awayFlagUrl = 'https://api.sofascore.com/api/v1/team/$awayTeamId/image';
    
    print('🏷️ Team IDs: Home=$homeTeamId ($homeTeam), Away=$awayTeamId ($awayTeam)');
    print('🖼️ Logo URLs: Home=$homeFlagUrl, Away=$awayFlagUrl');
    
    // Parse timestamp
    final startTimestamp = event['startTimestamp'] as int? ?? 0;
    final matchDateTime = DateTime.fromMillisecondsSinceEpoch(startTimestamp * 1000);
    
    // Format time
    final matchTime = '${matchDateTime.hour.toString().padLeft(2, '0')}:${matchDateTime.minute.toString().padLeft(2, '0')}';
    
    // Format date in Turkish format: "13 Ara, 2025"
    const monthNames = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    final monthName = monthNames[matchDateTime.month - 1];
    final matchDate = '${matchDateTime.day} $monthName, ${matchDateTime.year}';
    
    // Use the detected league name as group (clean name like "Premier League", "Süper Lig")
    final group = leagueName;
    
    // Get venue info
    final venue = event['venue'] ?? {};
    final city = venue['city']?['name'] as String? ?? _extractCityFromGroup(group);
    final stadium = venue['stadium']?['name'] as String? ?? 'Stadium';
    
    // Get scores and status
    final status = event['status'] ?? {};
    final statusCode = status['code'] as int? ?? 0;
    final statusDescription = status['description'] as String?;
    final statusType = status['type'] as String?;
    final isLive = statusCode == 6 || statusCode == 7; // 6 = 1st half, 7 = 2nd half
    final isFinished = statusCode == 100;
    
    // Extract live match time with Turkish localization
    String? liveMatchTime;
    if (isLive) {
      // Try to get actual minute from API
      // SofaScore can provide: "34'", "45+2'", "1st half", "2nd half", etc.
      if (statusDescription != null) {
        // If description contains actual minute (e.g., "34'" or "45+2'")
        if (statusDescription.contains("'")) {
          liveMatchTime = statusDescription;
        } 
        // If description is "1st half" or "2nd half", use Turkish equivalent
        else if (statusDescription.toLowerCase().contains('1st half')) {
          liveMatchTime = '1. Yarı';
        } 
        else if (statusDescription.toLowerCase().contains('2nd half')) {
          liveMatchTime = '2. Yarı';
        }
        else if (statusDescription.toLowerCase().contains('halftime')) {
          liveMatchTime = 'Devre Arası';
        }
        else {
          liveMatchTime = 'CANLI';
        }
      } else {
        // Fallback to status code if no description
        liveMatchTime = statusCode == 6 ? '1. Yarı' : '2. Yarı';
      }
    }
    
    int? homeScore;
    int? awayScore;
    
    if (isLive || isFinished) {
      final homeScoreData = event['homeScore'] ?? {};
      final awayScoreData = event['awayScore'] ?? {};
      homeScore = homeScoreData['current'] as int?;
      awayScore = awayScoreData['current'] as int?;
    }
    
    // Determine match status
    String matchStatus = 'notstarted';
    if (isFinished) {
      matchStatus = 'finished';
    } else if (isLive) {
      matchStatus = 'inprogress';
    }

    return MatchModel(
      id: id,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      homeFlagUrl: homeFlagUrl,
      awayFlagUrl: awayFlagUrl,
      matchTime: matchTime,
      matchDate: matchDate,
      city: city,
      stadium: stadium,
      group: group,
      category: leagueName, // Add league as category for display
      homeScore: homeScore,
      awayScore: awayScore,
      isLive: isLive,
      liveMatchTime: liveMatchTime,
      status: matchStatus,
      isHero: false, // Can be customized based on featured matches
      isFavorite: false,
      questions: _generatePredictionQuestions(id), // Generate prediction questions
    );
  }
  
  /// Generate prediction questions for a match
  List<PredictionQuestion> _generatePredictionQuestions(String matchId) {
    return [
      PredictionQuestion(
        id: '${matchId}_goals',
        text: 'Maçta 2.5 üstü gol olur mu?',
        yesPoints: 25,
        noPoints: 25,
      ),
      PredictionQuestion(
        id: '${matchId}_btts',
        text: 'Her iki takım gol atar mı?',
        yesPoints: 20,
        noPoints: 20,
      ),
      PredictionQuestion(
        id: '${matchId}_corner',
        text: '10+ korner olur mu?',
        yesPoints: 15,
        noPoints: 15,
      ),
      PredictionQuestion(
        id: '${matchId}_card',
        text: 'Kırmızı kart çıkar mı?',
        yesPoints: 30,
        noPoints: 30,
      ),
    ];
  }

  /// Extract city from group name (fallback)
  String _extractCityFromGroup(String group) {
    if (group.contains('Premier League')) return 'England';
    if (group.contains('Bundesliga')) return 'Germany';
    if (group.contains('Serie A')) return 'Italy';
    if (group.contains('Super Lig')) return 'Turkey';
    return 'Unknown';
  }

  @override
  Future<List<MatchModel>> getMatchesByDay(String dateKey) async {
    final allMatches = await getMatches();
    return allMatches.where((match) => match.matchDate == dateKey).toList();
  }

  @override
  Future<List<MatchModel>> getMatchesByGroup(String groupName) async {
    final allMatches = await getMatches();
    return allMatches.where((match) => match.group.contains(groupName)).toList();
  }

  @override
  Future<List<MatchModel>> getHeroMatches() async {
    final allMatches = await getMatches();
    // Return first 3 matches or live matches
    final liveMatches = allMatches.where((m) => m.isLive).toList();
    if (liveMatches.isNotEmpty) {
      return liveMatches.take(3).toList();
    }
    return allMatches.take(3).toList();
  }

  @override
  Future<void> savePrediction({
    required String matchId,
    required int homeScore,
    required int awayScore,
  }) async {
    // TODO: Implement prediction saving (requires backend)
    print('📝 Prediction saved for match $matchId: $homeScore-$awayScore');
    
    // Update cached match with prediction
    if (_cachedMatches != null) {
      final index = _cachedMatches!.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _cachedMatches![index] = _cachedMatches![index].copyWith(
          homeScore: homeScore,
          awayScore: awayScore,
        );
      }
    }
  }

  @override
  Future<void> saveExtraPrediction({
    required String matchId,
    required String questionId,
    required bool answer,
  }) async {
    // TODO: Implement extra prediction saving (requires backend)
    print('📝 Extra prediction saved for match $matchId: $questionId = $answer');
  }

  @override
  Future<void> toggleFavorite(String matchId, bool isFavorite) async {
    if (_cachedMatches != null) {
      final index = _cachedMatches!.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _cachedMatches![index] = _cachedMatches![index].copyWith(
          isFavorite: isFavorite,
        );
      }
    }
  }

  @override
  Future<List<GroupStanding>> getStandings(String groupName) async {
    // Not implemented for SofaScore (requires different endpoint)
    return [];
  }

  @override
  Future<Map<String, dynamic>> getUserPredictions(String userId) async {
    // TODO: Implement user predictions retrieval (requires backend)
    return {};
  }

  @override
  Future<int> calculateUserScore(String userId) async {
    // TODO: Implement score calculation (requires backend)
    return 0;
  }

  /// Clear cache to force refresh
  @override
  void clearCache() {
    _cachedMatches = null;
    print('🔄 SofaScore cache cleared');
  }
}
