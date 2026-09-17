import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  const GridBackground({
    super.key,
    this.cellSize = 40,
    this.lineColor = const Color(0xffd1d628),
    this.lineWidth = 1,
    this.child,
  });

  final double cellSize;
  final Color lineColor;
  final double lineWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand( 
      child: CustomPaint(
      painter: _GridPainter(
        cellSize: cellSize,
        lineColor: lineColor,
        lineWidth: lineWidth,
      ),
      child: child,
    ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.cellSize,
    required this.lineColor,
    required this.lineWidth,
  });

  final double cellSize;
  final Color lineColor;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    // Vertical lines
    for (double x = 0; x <= size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.cellSize != cellSize ||
      old.lineColor != lineColor ||
      old.lineWidth != lineWidth;
}