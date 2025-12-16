import 'member.dart';

class Group {
  final String id;
  final String name;
  final String description;
  final String adminName;
  final List<Member> members;
  final List<Member> podium; // top 3 as Member
  final List<Member> leaderboard; // ordered
  final Map<String, String> stats; // e.g. {'points': '1240', 'accuracy': '78%'}
  final String recentMessage;

  Group({
    required this.id,
    required this.name,
    this.description = '',
    this.adminName = '',
    this.members = const [],
    this.podium = const [],
    this.leaderboard = const [],
    this.stats = const {},
    this.recentMessage = '',
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      adminName: json['adminName'] as String? ?? '',
      members: (json['members'] as List<dynamic>?)?.map((e) => Member.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      podium: (json['podium'] as List<dynamic>?)?.map((e) => Member.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      leaderboard: (json['leaderboard'] as List<dynamic>?)?.map((e) => Member.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      stats: (json['stats'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k as String, v.toString())) ?? {},
      recentMessage: json['recentMessage'] as String? ?? '',
    );
  }

  // Convenience: dummy factory used by the local impl. Replace with backend data later.
  factory Group.dummy(String name) {
    final members = [
      Member(id: 'u1', name: 'Burak', avatarUrl: 'assets/images/team_logos/user1.png', isVerified: true, points: 1240),
      Member(id: 'u2', name: 'Ayşe', avatarUrl: 'assets/images/team_logos/user2.png', points: 1120),
      Member(id: 'u3', name: 'Mehmet', avatarUrl: 'assets/images/team_logos/user3.png', points: 1080),
      Member(id: 'u4', name: 'Zeynep', avatarUrl: 'assets/images/team_logos/user4.png', points: 1050),
      Member(id: 'u5', name: 'Sen', avatarUrl: 'assets/images/team_logos/user5.png', points: 1020),
      Member(id: 'u6', name: 'Ali', avatarUrl: 'assets/images/team_logos/user6.png', points: 990),
    ];
    return Group(
      id: 'g_${name.hashCode}',
      name: name,
      description: 'Beta group for testing',
      adminName: 'Burak',
      members: members,
      podium: [members[1], members[0], members[2]],
      leaderboard: members,
      stats: {'points': '1,240', 'accuracy': '78%', 'members': '${members.length}'},
      recentMessage: 'Burak sent a message...',
    );
  }
}
