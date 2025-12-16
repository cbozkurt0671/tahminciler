import 'prediction_question.dart';

/// Match model representing a football match
class MatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int? homeTeamId; // Team ID for fetching logo
  final int? awayTeamId; // Team ID for fetching logo
  final String homeFlagUrl; // Network URL for home team flag
  final String awayFlagUrl; // Network URL for away team flag
  final String matchTime;
  final String matchDate;
  final String city; // Host city (e.g., "New York", "Toronto")
  final String stadium; // Stadium name (e.g., "MetLife Stadium")
  final String group; // Group name (e.g., "A Grubu")
  final String? category; // League/Category name (e.g., "England", "Premier League")
  final int? homeScore;
  final int? awayScore;
  final List<String>? homeScorers;
  final List<String>? awayScorers;
  final bool isLive;
  final String? liveMatchTime; // Match minute for live matches (e.g., "34'")
  final String? status; // Match status (e.g., "notstarted", "inprogress", "finished")
  final bool isHero;
  final bool isFavorite;
  final List<PredictionQuestion> questions;
  final Map<String, String> userPredictions; // questionId -> answer (e.g., "q1" -> "EVET")
  final int? userPredictedHomeScore; // User's predicted home score
  final int? userPredictedAwayScore; // User's predicted away score

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamId,
    this.awayTeamId,
    required this.homeFlagUrl,
    required this.awayFlagUrl,
    required this.matchTime,
    required this.matchDate,
    required this.city,
    required this.stadium,
    required this.group,
    this.category,
    this.homeScore,
    this.awayScore,
    this.homeScorers,
    this.awayScorers,
    this.isLive = false,
    this.liveMatchTime,
    this.status,
    this.isHero = false,
    this.isFavorite = false,
    this.questions = const [],
    this.userPredictions = const {},
    this.userPredictedHomeScore,
    this.userPredictedAwayScore,
  });

  /// Returns formatted current score (e.g., "2 - 1")
  String? get currentScore {
    if (homeScore != null && awayScore != null) {
      return '$homeScore - $awayScore';
    }
    return null;
  }

  /// Check if predictions are locked (match is live or finished)
  bool get isPredictionLocked {
    return isLive || status == 'finished' || status == 'inprogress';
  }

  MatchModel copyWith({
    int? homeScore,
    int? awayScore,
    bool? isFavorite,
    List<PredictionQuestion>? questions,
    bool? isLive,
    String? liveMatchTime,
    String? status,
    Map<String, String>? userPredictions,
    int? userPredictedHomeScore,
    int? userPredictedAwayScore,
  }) {
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
      category: category,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      homeScorers: homeScorers,
      awayScorers: awayScorers,
      isLive: isLive ?? this.isLive,
      liveMatchTime: liveMatchTime ?? this.liveMatchTime,
      status: status ?? this.status,
      isHero: isHero,
      isFavorite: isFavorite ?? this.isFavorite,
      questions: questions ?? this.questions,
      userPredictions: userPredictions ?? this.userPredictions,
      userPredictedHomeScore: userPredictedHomeScore ?? this.userPredictedHomeScore,
      userPredictedAwayScore: userPredictedAwayScore ?? this.userPredictedAwayScore,
    );
  }
}
