import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NavBarPainter extends CustomPainter {
  final double position;
  final int itemCount;
  final bool isRtl;

  NavBarPainter({
    required this.position,
    required this.itemCount,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.navBarBackground
      ..style = PaintingStyle.fill;

    Path path = Path();

    double itemWidth = size.width / itemCount;

    final double clampedPosition = position.clamp(
      0.0,
      (itemCount - 1).toDouble(),
    );

    double adjustedPosition = isRtl
        ? (itemCount - 1 - clampedPosition)
        : clampedPosition;
    double centerPoint = (adjustedPosition * itemWidth) + (itemWidth / 2);

    double top = 20.0;
    double holeWidth = 70.0;
    double holeDepth = 40.0;

    path.moveTo(0, top);

    path.lineTo(centerPoint - (holeWidth / 2) - 10, top);

    path.cubicTo(
      centerPoint - (holeWidth / 3),
      top,
      centerPoint - (holeWidth / 2),
      top + holeDepth,
      centerPoint,
      top + holeDepth,
    );

    path.cubicTo(
      centerPoint + (holeWidth / 2),
      top + holeDepth,
      centerPoint + (holeWidth / 3),
      top,
      centerPoint + (holeWidth / 2) + 10,
      top,
    );

    path.lineTo(size.width, top);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.isRtl != isRtl ||
        oldDelegate.itemCount != itemCount;
  }
}
