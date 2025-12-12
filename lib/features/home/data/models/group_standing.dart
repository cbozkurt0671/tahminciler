/// Group standing model for World Cup groups
class GroupStanding {
  final String teamName;
  final String flagUrl;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  const GroupStanding({
    required this.teamName,
    required this.flagUrl,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  int get goalDifference => goalsFor - goalsAgainst;

  GroupStanding copyWith({
    String? teamName,
    String? flagUrl,
    int? played,
    int? won,
    int? drawn,
    int? lost,
    int? goalsFor,
    int? goalsAgainst,
    int? points,
  }) {
    return GroupStanding(
      teamName: teamName ?? this.teamName,
      flagUrl: flagUrl ?? this.flagUrl,
      played: played ?? this.played,
      won: won ?? this.won,
      drawn: drawn ?? this.drawn,
      lost: lost ?? this.lost,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      points: points ?? this.points,
    );
  }
}
