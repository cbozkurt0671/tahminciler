/// Duel entity for 1v1 challenges
class DuelEntity {
  final String id;
  final String challengerId;
  final String challengerName;
  final String opponentId;
  final String opponentName;
  final String matchId;
  final String matchName;
  final int stakeAmount;
  final DuelStatus status;
  final DateTime createdAt;
  final String? winnerId;
  final int? challengerScore;
  final int? opponentScore;

  const DuelEntity({
    required this.id,
    required this.challengerId,
    required this.challengerName,
    required this.opponentId,
    required this.opponentName,
    required this.matchId,
    required this.matchName,
    required this.stakeAmount,
    required this.status,
    required this.createdAt,
    this.winnerId,
    this.challengerScore,
    this.opponentScore,
  });

  DuelEntity copyWith({
    String? id,
    String? challengerId,
    String? challengerName,
    String? opponentId,
    String? opponentName,
    String? matchId,
    String? matchName,
    int? stakeAmount,
    DuelStatus? status,
    DateTime? createdAt,
    String? winnerId,
    int? challengerScore,
    int? opponentScore,
  }) {
    return DuelEntity(
      id: id ?? this.id,
      challengerId: challengerId ?? this.challengerId,
      challengerName: challengerName ?? this.challengerName,
      opponentId: opponentId ?? this.opponentId,
      opponentName: opponentName ?? this.opponentName,
      matchId: matchId ?? this.matchId,
      matchName: matchName ?? this.matchName,
      stakeAmount: stakeAmount ?? this.stakeAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      winnerId: winnerId ?? this.winnerId,
      challengerScore: challengerScore ?? this.challengerScore,
      opponentScore: opponentScore ?? this.opponentScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengerId': challengerId,
      'challengerName': challengerName,
      'opponentId': opponentId,
      'opponentName': opponentName,
      'matchId': matchId,
      'matchName': matchName,
      'stakeAmount': stakeAmount,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'winnerId': winnerId,
      'challengerScore': challengerScore,
      'opponentScore': opponentScore,
    };
  }

  factory DuelEntity.fromJson(Map<String, dynamic> json) {
    return DuelEntity(
      id: json['id'],
      challengerId: json['challengerId'],
      challengerName: json['challengerName'],
      opponentId: json['opponentId'],
      opponentName: json['opponentName'],
      matchId: json['matchId'],
      matchName: json['matchName'],
      stakeAmount: json['stakeAmount'],
      status: DuelStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => DuelStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      winnerId: json['winnerId'],
      challengerScore: json['challengerScore'],
      opponentScore: json['opponentScore'],
    );
  }
}

enum DuelStatus {
  pending,   // Waiting for match result
  completed, // Duel finished
  cancelled, // Duel cancelled
}

extension DuelStatusExtension on DuelStatus {
  String get displayName {
    switch (this) {
      case DuelStatus.pending:
        return 'Beklemede';
      case DuelStatus.completed:
        return 'Tamamlandı';
      case DuelStatus.cancelled:
        return 'İptal Edildi';
    }
  }
}
