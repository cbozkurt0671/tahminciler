import 'prediction_question.dart';

/// Match model representing a football match
class MatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String homeFlagUrl; // Network URL for home team flag
  final String awayFlagUrl; // Network URL for away team flag
  final String matchTime;
  final String matchDate;
  final String city; // Host city (e.g., "New York", "Toronto")
  final String stadium; // Stadium name (e.g., "MetLife Stadium")
  final String group; // Group name (e.g., "A Grubu")
  final int? homeScore;
  final int? awayScore;
  final List<String>? homeScorers;
  final List<String>? awayScorers;
  final bool isLive;
  final bool isHero;
  final bool isFavorite;
  final List<PredictionQuestion> questions;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeFlagUrl,
    required this.awayFlagUrl,
    required this.matchTime,
    required this.matchDate,
    required this.city,
    required this.stadium,
    required this.group,
    this.homeScore,
    this.awayScore,
    this.homeScorers,
    this.awayScorers,
    this.isLive = false,
    this.isHero = false,
    this.isFavorite = false,
    this.questions = const [],
  });

  MatchModel copyWith({
    int? homeScore,
    int? awayScore,
    bool? isFavorite,
    List<PredictionQuestion>? questions,
  }) {
    return MatchModel(
      id: id,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      homeFlagUrl: homeFlagUrl,
      awayFlagUrl: awayFlagUrl,
      matchTime: matchTime,
      matchDate: matchDate,
      city: city,
      stadium: stadium,
      group: group,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      homeScorers: homeScorers,
      awayScorers: awayScorers,
      isLive: isLive,
      isHero: isHero,
      isFavorite: isFavorite ?? this.isFavorite,
      questions: questions ?? this.questions,
    );
  }
}
