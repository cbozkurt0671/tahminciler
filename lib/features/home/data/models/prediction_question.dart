/// Model representing a dynamic prediction question for a match
class PredictionQuestion {
  final String id;
  final String text;
  final int yesPoints;
  final int noPoints;

  const PredictionQuestion({
    required this.id,
    required this.text,
    required this.yesPoints,
    required this.noPoints,
  });

  /// Factory constructor for JSON deserialization
  factory PredictionQuestion.fromJson(Map<String, dynamic> json) {
    return PredictionQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      yesPoints: json['yesPoints'] as int,
      noPoints: json['noPoints'] as int,
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'yesPoints': yesPoints,
      'noPoints': noPoints,
    };
  }

  /// Create a copy with modified fields
  PredictionQuestion copyWith({
    String? id,
    String? text,
    int? yesPoints,
    int? noPoints,
  }) {
    return PredictionQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      yesPoints: yesPoints ?? this.yesPoints,
      noPoints: noPoints ?? this.noPoints,
    );
  }
}
