import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Fetches team logo from Sofascore API with proper headers to bypass 403 errors
/// 
/// Returns null if the request fails
Future<Uint8List?> fetchTeamLogo(int teamId) async {
  try {
    final url = Uri.parse('https://api.sofascore.com/api/v1/team/$teamId/image');
    
    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': 'https://www.sofascore.com/',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      debugPrint('✅ Team logo fetched successfully: teamId=$teamId');
      return response.bodyBytes;
    } else {
      debugPrint('⚠️ Failed to fetch team logo: teamId=$teamId, statusCode=${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('❌ Error fetching team logo: teamId=$teamId, error=$e');
    return null;
  }
}

/// Reusable widget to display team logos from Sofascore API
/// 
/// Handles loading states, errors, and displays the logo at configurable size
class TeamLogoWidget extends StatelessWidget {
  final int teamId;
  final double size;
  final BoxFit fit;
  final Color? fallbackIconColor;

  const TeamLogoWidget({
    super.key,
    required this.teamId,
    this.size = 40,
    this.fit = BoxFit.contain,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: fetchTeamLogo(teamId),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: size,
            height: size,
            child: Center(
              child: SizedBox(
                width: size * 0.5,
                height: size * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    fallbackIconColor ?? Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }

        // Error or null data state
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Icon(
            Icons.shield_outlined,
            size: size,
            color: fallbackIconColor ?? Colors.grey.withOpacity(0.5),
          );
        }

        // Success state - display the logo
        return Image.memory(
          snapshot.data!,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Error displaying team logo: teamId=$teamId, error=$error');
            return Icon(
              Icons.shield_outlined,
              size: size,
              color: fallbackIconColor ?? Colors.grey.withOpacity(0.5),
            );
          },
        );
      },
    );
  }
}

/// Cached version of TeamLogoWidget that prevents redundant network calls
/// 
/// Uses a simple in-memory cache for the current session
class CachedTeamLogoWidget extends StatefulWidget {
  final int teamId;
  final double size;
  final BoxFit fit;
  final Color? fallbackIconColor;

  const CachedTeamLogoWidget({
    super.key,
    required this.teamId,
    this.size = 40,
    this.fit = BoxFit.contain,
    this.fallbackIconColor,
  });

  @override
  State<CachedTeamLogoWidget> createState() => _CachedTeamLogoWidgetState();
}

class _CachedTeamLogoWidgetState extends State<CachedTeamLogoWidget> {
  static final Map<int, Uint8List?> _cache = {};
  
  Future<Uint8List?> _fetchWithCache() async {
    if (_cache.containsKey(widget.teamId)) {
      debugPrint('📦 Using cached logo: teamId=${widget.teamId}');
      return _cache[widget.teamId];
    }
    
    final bytes = await fetchTeamLogo(widget.teamId);
    _cache[widget.teamId] = bytes;
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _fetchWithCache(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: SizedBox(
                width: widget.size * 0.5,
                height: widget.size * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.fallbackIconColor ?? Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }

        // Error or null data state
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Icon(
            Icons.shield_outlined,
            size: widget.size,
            color: widget.fallbackIconColor ?? Colors.grey.withOpacity(0.5),
          );
        }

        // Success state - display the logo
        return Image.memory(
          snapshot.data!,
          width: widget.size,
          height: widget.size,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Error displaying team logo: teamId=${widget.teamId}, error=$error');
            return Icon(
              Icons.shield_outlined,
              size: widget.size,
              color: widget.fallbackIconColor ?? Colors.grey.withOpacity(0.5),
            );
          },
        );
      },
    );
  }
}
