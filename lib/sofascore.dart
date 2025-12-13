import 'package:flutter/material.dart';

/// Model for a match coming from SofaScore-like JSON.
///
/// Fields follow the user's specification. `id` is required.
class SofaMatch {
  final int id;
  final int? startTimestamp; // seconds since epoch
  final String? homeTeamName;
  final String? awayTeamName;
  final int? homeTeamId; // Home team ID for logo URL
  final int? awayTeamId; // Away team ID for logo URL
  final String? homeTeamColor; // hex string like "#374df5"
  final String? awayTeamColor;
  final String? leagueName;
  final int? round;
  final String? status; // Legacy field (status.type or status.description)
  final Map<String, dynamic>? statusObject; // Full status object for detailed parsing
  final int? homeScore;
  final int? awayScore;

  SofaMatch({
    required this.id,
    this.startTimestamp,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamColor,
    this.awayTeamColor,
    this.leagueName,
    this.round,
    this.status,
    this.statusObject,
    this.homeScore,
    this.awayScore,
  });

  /// Returns true if match is currently in progress
  bool get isLive {
    if (statusObject != null && statusObject!['type'] != null) {
      return statusObject!['type'] == 'inprogress';
    }
    // Fallback to legacy status string
    return status?.toLowerCase() == 'inprogress';
  }

  /// Returns current match time with Turkish localization
  /// Returns null if match hasn't started yet
  String? get matchTime {
    if (!isLive) return null;
    
    if (statusObject != null && statusObject!['description'] != null) {
      final description = statusObject!['description'] as String;
      
      // If description contains actual minute (e.g., "34'" or "45+2'")
      if (description.contains("'")) {
        return description;
      }
      // Localize half indicators
      else if (description.toLowerCase().contains('1st half')) {
        return '1. Yarı';
      }
      else if (description.toLowerCase().contains('2nd half')) {
        return '2. Yarı';
      }
      else if (description.toLowerCase().contains('halftime')) {
        return 'Devre Arası';
      }
      
      return description; // Return as-is if unknown format
    }
    
    return null;
  }

  /// Returns current score in "homeScore - awayScore" format (e.g., "2 - 1")
  /// Returns null if scores are not available
  String? get currentScore {
    if (homeScore != null && awayScore != null) {
      return '$homeScore - $awayScore';
    }
    return null;
  }

  /// Converts the integer timestamp (seconds) to [DateTime].
  /// Returns null if [startTimestamp] is null.
  DateTime? get startDateTime {
    if (startTimestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(startTimestamp! * 1000);
  }

  /// Convenience getters returning Flutter [Color]s. If the hex string is null
  /// or invalid, a sensible default grey is returned.
  Color get homeColor => colorFromHex(homeTeamColor);
  Color get awayColor => colorFromHex(awayTeamColor);

  /// Getter for home team logo URL using .com domain with browser headers
  String get homeTeamLogoUrl =>
      'https://api.sofascore.com/api/v1/team/$homeTeamId/image';

  /// Getter for away team logo URL using .com domain with browser headers
  String get awayTeamLogoUrl =>
      'https://api.sofascore.com/api/v1/team/$awayTeamId/image';

  /// Factory to create [SofaMatch] from SofaScore-like JSON.
  factory SofaMatch.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return SofaMatch(
      id: json['id'] as int,
      startTimestamp: parseNullableInt(json['startTimestamp']),
      homeTeamName: (json['homeTeam'] != null && json['homeTeam']['name'] != null)
          ? json['homeTeam']['name'] as String
          : null,
      awayTeamName: (json['awayTeam'] != null && json['awayTeam']['name'] != null)
          ? json['awayTeam']['name'] as String
          : null,
      homeTeamId: json['homeTeam'] != null
          ? parseNullableInt(json['homeTeam']['id'])
          : null,
      awayTeamId: json['awayTeam'] != null
          ? parseNullableInt(json['awayTeam']['id'])
          : null,
      homeTeamColor: json['homeTeam'] != null
          ? (json['homeTeam']['teamColors'] != null
              ? json['homeTeam']['teamColors']['primary'] as String?
              : null)
          : null,
      awayTeamColor: json['awayTeam'] != null
          ? (json['awayTeam']['teamColors'] != null
              ? json['awayTeam']['teamColors']['primary'] as String?
              : null)
          : null,
      leagueName: json['season'] != null ? json['season']['name'] as String? : null,
      round: json['roundInfo'] != null ? parseNullableInt(json['roundInfo']['round']) : null,
      status: json['status'] != null
          ? (json['status']['type'] as String? ?? json['status']['description'] as String?)
          : null,
      statusObject: json['status'] != null
          ? Map<String, dynamic>.from(json['status'] as Map)
          : null,
      homeScore: json['homeScore'] != null ? parseNullableInt(json['homeScore']['current']) : null,
      awayScore: json['awayScore'] != null ? parseNullableInt(json['awayScore']['current']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTimestamp': startTimestamp,
        'homeTeam': {
          'id': homeTeamId,
          'name': homeTeamName,
          'teamColors': {'primary': homeTeamColor}
        },
        'awayTeam': {
          'id': awayTeamId,
          'name': awayTeamName,
          'teamColors': {'primary': awayTeamColor}
        },
        'season': {'name': leagueName},
        'roundInfo': {'round': round},
        'status': {'type': status},
        'homeScore': {'current': homeScore},
        'awayScore': {'current': awayScore},
      };
}

/// Converts a hex color string (e.g. "#374df5" or "374df5") to [Color].
///
/// If [hex] is null, empty, or invalid, returns [Colors.grey].
Color colorFromHex(String? hex) {
  if (hex == null) return Colors.grey;
  final cleaned = hex.replaceAll('#', '').trim();
  if (cleaned.isEmpty) return Colors.grey;

  String normalized = cleaned.toUpperCase();
  // Handle short 3-char hex like 'abc' -> 'AABBCC'
  if (normalized.length == 3) {
    final r = normalized[0];
    final g = normalized[1];
    final b = normalized[2];
    normalized = '$r$r$g$g$b$b';
  }

  // If only RRGGBB provided, prepend alpha FF
  if (normalized.length == 6) normalized = 'FF$normalized';

  // Now normalized should be 8 chars (AARRGGBB)
  if (normalized.length != 8) return Colors.grey;

  final value = int.tryParse(normalized, radix: 16);
  if (value == null) return Colors.grey;
  return Color(value + 0x00000000); // value already AARRGGBB
}

/// Parse a list of JSON objects (from the API) into a deduplicated and
/// date-sorted list of [SofaMatch].
///
/// - Uses a Map<int, SofaMatch> to upsert matches by their `id` (prevents
///   duplicates).
/// - Returns a List sorted by `startTimestamp` ascending (earlier first).
List<SofaMatch> parseMatches(List<dynamic> jsonList) {
  final Map<int, SofaMatch> map = {};

  for (final item in jsonList) {
    if (item == null) continue;
    try {
      final Map<String, dynamic> obj = item is Map<String, dynamic>
          ? item
          : Map<String, dynamic>.from(item as Map);
      final match = SofaMatch.fromJson(obj);
      // Upsert by id — later items overwrite earlier ones
      map[match.id] = match;
    } catch (_) {
      // If a single item fails parsing, skip it. Keep parsing others.
      continue;
    }
  }

  final List<SofaMatch> result = map.values.toList();
  result.sort((a, b) {
    final ta = a.startTimestamp ?? 0;
    final tb = b.startTimestamp ?? 0;
    return ta.compareTo(tb);
  });

  return result;
}
