import 'power_up_entity.dart';

/// User entity representing an app user
class UserEntity {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final int totalPoints;
  final int globalRank;
  final int correctPredictions;
  final int totalPredictions;
  final List<String> badges;
  final List<PowerUpEntity> powerUps;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.totalPoints,
    required this.globalRank,
    this.correctPredictions = 0,
    this.totalPredictions = 0,
    this.badges = const [],
    this.powerUps = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Calculate win rate percentage
  double get winRate {
    if (totalPredictions == 0) return 0.0;
    return (correctPredictions / totalPredictions) * 100;
  }

  /// Get initials for avatar placeholder
  String get initials {
    final parts = username.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return username.substring(0, 2).toUpperCase();
  }

  UserEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    int? totalPoints,
    int? globalRank,
    int? correctPredictions,
    int? totalPredictions,
    List<String>? badges,
    List<PowerUpEntity>? powerUps,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalPoints: totalPoints ?? this.totalPoints,
      globalRank: globalRank ?? this.globalRank,
      correctPredictions: correctPredictions ?? this.correctPredictions,
      totalPredictions: totalPredictions ?? this.totalPredictions,
      badges: badges ?? this.badges,
      powerUps: powerUps ?? this.powerUps,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'totalPoints': totalPoints,
      'globalRank': globalRank,
      'correctPredictions': correctPredictions,
      'totalPredictions': totalPredictions,
      'badges': badges,
      'powerUps': powerUps.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      totalPoints: json['totalPoints'] ?? 0,
      globalRank: json['globalRank'] ?? 0,
      correctPredictions: json['correctPredictions'] ?? 0,
      totalPredictions: json['totalPredictions'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
      powerUps: (json['powerUps'] as List?)
          ?.map((p) => PowerUpEntity.fromJson(p))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
