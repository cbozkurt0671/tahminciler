import 'package:flutter/material.dart';

class BracketPainter extends CustomPainter {
  final List<double> leftCenters;
  final List<double> rightCenters;
  final bool isActive;

  BracketPainter({required this.leftCenters, required this.rightCenters, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? const Color(0xFF0df259) : const Color(0xFF444444)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double startX = 0;
    final double endX = size.width;
    final double midX = size.width / 2;

    // For each left match center, connect it to the appropriate right match center
    for (var i = 0; i < leftCenters.length; i++) {
      final startY = leftCenters[i];
      final rightIndex = i ~/ 2;
      if (rightIndex < rightCenters.length) {
        final endY = rightCenters[rightIndex];

        final path = Path();
        path.moveTo(startX, startY);
        // Horizontal to mid, vertical to endY, then horizontal to end
        path.lineTo(midX, startY);
        path.lineTo(midX, endY);
        path.lineTo(endX, endY);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BracketPainter oldDelegate) {
    return oldDelegate.leftCenters != leftCenters || oldDelegate.rightCenters != rightCenters || oldDelegate.isActive != isActive;
  }
}

class BracketConnector extends StatelessWidget {
  final List<double> leftCenters;
  final List<double> rightCenters;
  final bool isActive;

  const BracketConnector({
    super.key,
    required this.leftCenters,
    required this.rightCenters,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BracketPainter(leftCenters: leftCenters, rightCenters: rightCenters, isActive: isActive),
    );
  }
}