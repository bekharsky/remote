import 'dart:math';
import 'package:flutter/material.dart';

class DPadWidget extends StatefulWidget {
  final int slices;
  final List<Color> colors;
  final double size; // Static size parameter
  final Function(int)? onSliceClick; // Callback for slice clicks
  final Function()? onCenterClick; // Callback for center circle clicks

  DPadWidget({
    Key? key,
    this.slices = 4,
    this.colors = const [
      Colors.green,
      Colors.grey,
      Colors.blue,
      Colors.red,
    ],
    this.size = 200.0,
    this.onSliceClick,
    this.onCenterClick,
  }) : super(key: key);

  @override
  _DPadWidgetState createState() => _DPadWidgetState();
}

class _DPadWidgetState extends State<DPadWidget> {
  int? highlightedSlice;
  bool centerHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _handleTap,
      onTapCancel: _resetHighlight, // Reset highlights on tap cancel
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _DPadPainter(
          slices: widget.slices,
          colors: widget.colors,
          size: widget.size,
          highlightedSlice: highlightedSlice,
          centerHighlighted: centerHighlighted,
        ),
      ),
    );
  }

  void _handleTap(TapUpDetails details) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - center.dx;
    final dy = touchPosition.dy - center.dy;
    final distanceSquare = dx * dx + dy * dy;

    final outerRadius = widget.size * 0.5;
    final innerRadius = outerRadius * 0.5;

    if (distanceSquare < innerRadius * innerRadius) {
      setState(() {
        centerHighlighted = true;
        highlightedSlice = null;
      });
      widget.onCenterClick?.call();
      return;
    }

    if (distanceSquare > innerRadius * innerRadius &&
        distanceSquare < outerRadius * outerRadius) {
      final angle = atan2(dy, dx);
      final adjustedAngle = (angle + pi / 4) % (2 * pi);

      final sliceIndex =
          (adjustedAngle / (2 * pi) * widget.slices).floor() % widget.slices;

      setState(() {
        highlightedSlice = sliceIndex;
        centerHighlighted = false;
      });

      widget.onSliceClick?.call(sliceIndex);
    }
  }

  void _resetHighlight() {
    setState(() {
      highlightedSlice = null;
      centerHighlighted = false;
    });
  }
}

class _DPadPainter extends CustomPainter {
  final int slices;
  final List<Color> colors;
  final double size;
  final int? highlightedSlice;
  final bool centerHighlighted;

  _DPadPainter({
    required this.slices,
    required this.colors,
    required this.size,
    this.highlightedSlice,
    this.centerHighlighted = false,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.5;
    final innerRadius = outerRadius * 0.5;
    final paint = Paint();

    // Draw slices
    double startAngle = -pi / 4;
    double sweepAngle = 2 * pi / slices;

    for (int i = 0; i < slices; i++) {
      paint.color =
          highlightedSlice == i ? Colors.yellow : colors[i % colors.length];
      paint.style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      paint.color = Colors.white;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    paint.style = PaintingStyle.fill;
    paint.color = centerHighlighted ? Colors.yellow : Colors.black;
    canvas.drawCircle(center, innerRadius, paint);

    paint.style = PaintingStyle.stroke;
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    canvas.drawCircle(center, innerRadius, paint);
  }

  @override
  bool shouldRepaint(_DPadPainter oldDelegate) {
    return true;
  }
}
