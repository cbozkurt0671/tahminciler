/// League message entity for chat and system events
class LeagueMessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final LeagueMessageType type;
  final DateTime timestamp;
  final String? senderAvatar;

  const LeagueMessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.type,
    required this.timestamp,
    this.senderAvatar,
  });

  LeagueMessageEntity copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? text,
    LeagueMessageType? type,
    DateTime? timestamp,
    String? senderAvatar,
  }) {
    return LeagueMessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      senderAvatar: senderAvatar ?? this.senderAvatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'senderAvatar': senderAvatar,
    };
  }

  factory LeagueMessageEntity.fromJson(Map<String, dynamic> json) {
    return LeagueMessageEntity(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      text: json['text'],
      type: LeagueMessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => LeagueMessageType.chat,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      senderAvatar: json['senderAvatar'],
    );
  }

  String get initials {
    final parts = senderName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return senderName.substring(0, 2).toUpperCase();
  }
}

enum LeagueMessageType {
  chat,
  systemEvent,
  jokerUsed,
  duelChallenge,
  duelResult,
}

extension LeagueMessageTypeExtension on LeagueMessageType {
  String get icon {
    switch (this) {
      case LeagueMessageType.chat:
        return '💬';
      case LeagueMessageType.systemEvent:
        return '📢';
      case LeagueMessageType.jokerUsed:
        return '🃏';
      case LeagueMessageType.duelChallenge:
        return '⚔️';
      case LeagueMessageType.duelResult:
        return '🏆';
    }
  }
}
