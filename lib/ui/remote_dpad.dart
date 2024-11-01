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
    this.slices = 4, // Set to 4 for four arcs
    this.colors = const [
      Colors.green,
      Colors.grey,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.grey,
      Colors.blue,
      Colors.red,
    ],
    this.size = 200.0, // Default size of 200
    this.onSliceClick,
    this.onCenterClick,
  }) : super(key: key);

  @override
  _DPadWidgetState createState() => _DPadWidgetState();
}

class _DPadWidgetState extends State<DPadWidget> {
  int? highlightedSlice; // Store the highlighted slice index
  bool centerHighlighted = false; // Track if center is highlighted

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _handleTap,
      onTapCancel: _resetHighlight, // Reset highlights on tap cancel
      child: CustomPaint(
        size: Size(widget.size, widget.size), // Use the static size
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
    final center =
        Offset(widget.size / 2, widget.size / 2); // Center of the DPad
    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - center.dx;
    final dy = touchPosition.dy - center.dy;
    final distanceSquare = dx * dx + dy * dy;

    final outerRadius = widget.size * 0.4; // Outer radius (40% of the size)
    final innerRadius = outerRadius * 0.5; // Inner radius (50% of outer radius)

    // Check if the tap is within the inner circle
    if (distanceSquare < innerRadius * innerRadius) {
      setState(() {
        centerHighlighted = true; // Highlight center circle
        highlightedSlice = null; // Clear slice highlight
      });
      widget.onCenterClick?.call();
      return; // Exit if center circle is clicked
    }

    // Check if the tap is within the clickable area of the slices
    if (distanceSquare > innerRadius * innerRadius &&
        distanceSquare < outerRadius * outerRadius) {
      final angle = atan2(dy, dx); // Calculate the angle
      final adjustedAngle = (angle + pi / 4) %
          (2 * pi); // Adjust angle to align the first arc with the top

      // Determine which slice was clicked
      final sliceIndex =
          (adjustedAngle / (2 * pi) * widget.slices).floor() % widget.slices;

      setState(() {
        highlightedSlice = sliceIndex; // Highlight the clicked slice
        centerHighlighted = false; // Clear center highlight
      });
      widget.onSliceClick?.call(sliceIndex);
    }
  }

  void _resetHighlight() {
    setState(() {
      highlightedSlice = null; // Clear slice highlight
      centerHighlighted = false; // Clear center highlight
    });
  }
}

class _DPadPainter extends CustomPainter {
  final int slices;
  final List<Color> colors;
  final double size;
  final int? highlightedSlice; // Index of the highlighted slice
  final bool centerHighlighted; // Flag to indicate if center is highlighted

  _DPadPainter({
    required this.slices,
    required this.colors,
    required this.size,
    this.highlightedSlice,
    this.centerHighlighted = false,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center =
        Offset(size.width / 2, size.height / 2); // Center of the CustomPaint
    final outerRadius = size.width * 0.4; // Outer radius (40% of the size)
    final innerRadius =
        outerRadius * 0.5; // Inner circle size (50% of outer radius)
    final paint = Paint();

    // Draw slices
    double startAngle =
        -pi / 4; // Start angle adjusted to face the top of the first arc
    double sweepAngle = 2 * pi / slices;

    for (int i = 0; i < slices; i++) {
      // Draw the arc
      paint.color = highlightedSlice == i
          ? Colors.yellow // Highlighted color
          : colors[i % colors.length]; // Regular slice color
      paint.style = PaintingStyle.fill; // Fill style for arcs
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw border
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

      startAngle += sweepAngle; // Increment the start angle for the next arc
    }

    // Draw inner circle
    paint.style = PaintingStyle.fill;
    paint.color = centerHighlighted
        ? Colors.yellow
        : Colors.black; // Highlight center circle
    canvas.drawCircle(center, innerRadius, paint);

    // Draw inner circle border
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
