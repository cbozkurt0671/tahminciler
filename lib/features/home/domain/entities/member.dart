class Member {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;
  final int points;

  Member({required this.id, required this.name, required this.avatarUrl, this.isVerified = false, this.points = 0});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      points: json['points'] as int? ?? 0,
    );
  }
}
