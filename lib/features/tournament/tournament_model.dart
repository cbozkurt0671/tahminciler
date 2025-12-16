class TournamentMatch {
  final String id;
  final String? nextMatchId;
  final int roundIndex;
  String? team1;
  String? team2;
  String? winner;

  TournamentMatch({
    required this.id,
    this.nextMatchId,
    required this.roundIndex,
    this.team1,
    this.team2,
    this.winner,
  });

  bool get isEmpty => team1 == null && team2 == null;
}