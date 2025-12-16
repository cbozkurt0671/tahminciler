class Team {
  final String id;
  final String name;
  final String logoUrl;

  Team({required this.id, required this.name, required this.logoUrl});
}

class Match {
  final String id;
  final int roundIndex;
  Team? team1;
  Team? team2;
  Team? winner;
  final String? nextMatchId;

  Match({
    required this.id,
    required this.roundIndex,
    this.team1,
    this.team2,
    this.winner,
    this.nextMatchId,
  });

  bool get isEmpty => team1 == null && team2 == null;
}