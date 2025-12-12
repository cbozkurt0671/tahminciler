import 'user_entity.dart';

/// League member with their specific score in that league
class LeagueMember {
  final UserEntity user;
  final int leaguePoints;
  final int leagueRank;
  final int weeklyChange; // Points gained/lost this week

  LeagueMember({
    required this.user,
    required this.leaguePoints,
    required this.leagueRank,
    this.weeklyChange = 0,
  });

  LeagueMember copyWith({
    UserEntity? user,
    int? leaguePoints,
    int? leagueRank,
    int? weeklyChange,
  }) {
    return LeagueMember(
      user: user ?? this.user,
      leaguePoints: leaguePoints ?? this.leaguePoints,
      leagueRank: leagueRank ?? this.leagueRank,
      weeklyChange: weeklyChange ?? this.weeklyChange,
    );
  }
}

/// Private prediction league entity
class LeagueEntity {
  final String id;
  final String name;
  final String inviteCode;
  final String ownerId;
  final List<LeagueMember> members;
  final DateTime createdAt;
  final int totalMembers;

  LeagueEntity({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.ownerId,
    required this.members,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        totalMembers = members.length;

  /// Get member by user ID
  LeagueMember? getMember(String userId) {
    try {
      return members.firstWhere((m) => m.user.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Get top 3 members
  List<LeagueMember> get topThree {
    final sorted = List<LeagueMember>.from(members)
      ..sort((a, b) => b.leaguePoints.compareTo(a.leaguePoints));
    return sorted.take(3).toList();
  }

  /// Get last place member (for gamification)
  LeagueMember? get lastPlace {
    if (members.isEmpty) return null;
    final sorted = List<LeagueMember>.from(members)
      ..sort((a, b) => b.leaguePoints.compareTo(a.leaguePoints));
    return sorted.last;
  }

  LeagueEntity copyWith({
    String? id,
    String? name,
    String? inviteCode,
    String? ownerId,
    List<LeagueMember>? members,
    DateTime? createdAt,
  }) {
    return LeagueEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'inviteCode': inviteCode,
      'ownerId': ownerId,
      'members': members.map((m) => {
        'user': m.user.toJson(),
        'leaguePoints': m.leaguePoints,
        'leagueRank': m.leagueRank,
        'weeklyChange': m.weeklyChange,
      }).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LeagueEntity.fromJson(Map<String, dynamic> json) {
    return LeagueEntity(
      id: json['id'],
      name: json['name'],
      inviteCode: json['inviteCode'],
      ownerId: json['ownerId'],
      members: (json['members'] as List).map((m) => LeagueMember(
        user: UserEntity.fromJson(m['user']),
        leaguePoints: m['leaguePoints'],
        leagueRank: m['leagueRank'],
        weeklyChange: m['weeklyChange'] ?? 0,
      )).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
