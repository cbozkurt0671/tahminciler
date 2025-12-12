/// Power-Up (Joker) entity for strategic gameplay
class PowerUpEntity {
  final String id;
  final String name;
  final String icon;
  final int count;
  final String description;
  final PowerUpType type;

  const PowerUpEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
    required this.description,
    required this.type,
  });

  PowerUpEntity copyWith({
    String? id,
    String? name,
    String? icon,
    int? count,
    String? description,
    PowerUpType? type,
  }) {
    return PowerUpEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      count: count ?? this.count,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'count': count,
      'description': description,
      'type': type.toString(),
    };
  }

  factory PowerUpEntity.fromJson(Map<String, dynamic> json) {
    return PowerUpEntity(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      count: json['count'],
      description: json['description'],
      type: PowerUpType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PowerUpType.spy,
      ),
    );
  }
}

enum PowerUpType {
  spy,      // Casus - See others' predictions
  booster,  // x2 - Double points
  shield,   // Sigorta - Protection from loss
}

extension PowerUpTypeExtension on PowerUpType {
  String get displayName {
    switch (this) {
      case PowerUpType.spy:
        return 'Casus';
      case PowerUpType.booster:
        return 'x2 Çarpan';
      case PowerUpType.shield:
        return 'Sigorta';
    }
  }

  String get emoji {
    switch (this) {
      case PowerUpType.spy:
        return '🕵️';
      case PowerUpType.booster:
        return '⚡';
      case PowerUpType.shield:
        return '🛡️';
    }
  }

  String get description {
    switch (this) {
      case PowerUpType.spy:
        return 'Rakiplerin tahminlerini gör';
      case PowerUpType.booster:
        return 'Kazanç/Kayıp x2';
      case PowerUpType.shield:
        return 'Puan kaybına karşı koruma';
    }
  }
}
