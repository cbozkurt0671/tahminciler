import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BetaAvatar: shows an asset avatar if available, otherwise a generated initials circle.
class BetaAvatar extends StatelessWidget {
  final String? imagePath; // local asset path
  final double size;
  final String? initials;
  final String? name;
  final Color borderColor;
  final double borderWidth;
  final bool verified;

  const BetaAvatar({
    Key? key,
    this.imagePath,
    this.size = 40,
  this.initials,
  this.name,
    this.borderColor = const Color(0xFF0df259),
    this.borderWidth = 2.0,
    this.verified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = Colors.grey[900]!;
  final source = (initials ?? name ?? '').trim();
  final text = source.isEmpty
    ? ''
    : source.split(RegExp(r'\s+')).map((s) => s.isNotEmpty ? s[0].toUpperCase() : '').take(2).join();

    Widget avatar;
    if (imagePath != null && imagePath!.isNotEmpty) {
      avatar = ClipOval(
        child: Image.asset(
          imagePath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            color: bg,
            child: Center(
              child: Text(
                text.isEmpty ? '?' : text,
                style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.36),
              ),
            ),
          ),
        ),
      );
    } else {
      avatar = Container(
        width: size,
        height: size,
        color: bg,
        child: Center(
          child: Text(
            text.isEmpty ? '?' : text,
            style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.36),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size + borderWidth * 2,
          height: size + borderWidth * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipOval(child: SizedBox(width: size, height: size, child: avatar)),
        ),
        if (verified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(Icons.verified, color: borderColor, size: size * 0.22),
            ),
          ),
      ],
    );
  }
}
