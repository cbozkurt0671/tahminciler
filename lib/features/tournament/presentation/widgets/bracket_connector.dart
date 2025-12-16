import 'package:flutter/material.dart';

class BracketConnector extends StatelessWidget {
  final bool isActive;

  const BracketConnector({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BracketPainter(isActive: isActive),
      size: const Size(100, 100), // Adjust size as needed
    );
  }
}

class BracketPainter extends CustomPainter {
  final bool isActive;

  BracketPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? const Color(0xFF0df259) : const Color(0xFF333333)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw elbow line: horizontal then vertical
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}