import 'dart:math';
import 'package:flutter/material.dart';

class RemoteDPad extends StatefulWidget {
  final int slices;
  final List<Color> colors;
  final Color activeColor;
  final double size;
  final Function(int)? onSliceClick;
  final Function()? onCenterClick;

  const RemoteDPad({
    Key? key,
    this.slices = 4,
    required this.colors,
    required this.activeColor,
    this.size = 200.0,
    this.onSliceClick,
    this.onCenterClick,
  }) : super(key: key);

  @override
  _RemoteDPadState createState() => _RemoteDPadState();
}

class _RemoteDPadState extends State<RemoteDPad>
    with SingleTickerProviderStateMixin {
  int? highlightedSlice;
  bool centerHighlighted = false;

  late AnimationController _animationController;
  late Animation<Color?> _highlightAnimation;
  Color? _currentHighlightColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _highlightAnimation = ColorTween(
      begin: widget.activeColor,
      end: widget.colors[0],
    ).animate(_animationController);

    _highlightAnimation.addListener(() {
      setState(() {
        _currentHighlightColor = _highlightAnimation.value;
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          highlightedSlice = null;
          centerHighlighted = false;
          _currentHighlightColor = widget.colors[0];
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _resetHighlight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _DPadPainter(
              slices: widget.slices,
              colors: widget.colors,
              size: widget.size,
              highlightedSlice: highlightedSlice,
              centerHighlighted: centerHighlighted,
              highlightColor: _currentHighlightColor ?? widget.activeColor,
            ),
          ),
          // Position icons in each segment
          Positioned(
            top: widget.size * 0.0675,
            child: const Icon(
              Icons.keyboard_arrow_up,
              size: 30,
              color: Colors.white60,
            ),
          ),
          Positioned(
            right: widget.size * 0.0675,
            child: const Icon(
              Icons.keyboard_arrow_right,
              size: 30,
              color: Colors.white60,
            ),
          ),
          Positioned(
            bottom: widget.size * 0.0675,
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: Colors.white60,
            ),
          ),
          Positioned(
            left: widget.size * 0.0675,
            child: const Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - center.dx;
    final dy = touchPosition.dy - center.dy;
    final distanceSquare = dx * dx + dy * dy;

    final outerRadius = widget.size * 0.5;
    final innerRadius = outerRadius * 0.5;

    _animationController.stop();
    _currentHighlightColor = widget.activeColor;

    if (distanceSquare < innerRadius * innerRadius) {
      setState(() {
        centerHighlighted = true;
        highlightedSlice = null;
      });
      widget.onCenterClick?.call();
    } else if (distanceSquare > innerRadius * innerRadius &&
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

  void _handleTapUp(TapUpDetails details) {
    _animationController.forward(from: 0);
  }

  void _resetHighlight() {
    setState(() {
      highlightedSlice = null;
      centerHighlighted = false;
      _currentHighlightColor = widget.colors[0];
    });
  }
}

class _DPadPainter extends CustomPainter {
  final int slices;
  final List<Color> colors;
  final double size;
  final int? highlightedSlice;
  final bool centerHighlighted;
  final Color highlightColor;

  _DPadPainter({
    required this.slices,
    required this.colors,
    required this.size,
    this.highlightedSlice,
    this.centerHighlighted = false,
    required this.highlightColor,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.5;
    final innerRadius = outerRadius * 0.5;
    final paint = Paint();

    double startAngle = -pi / 4;
    double sweepAngle = 2 * pi / slices;

    for (int i = 0; i < slices; i++) {
      paint.color =
          highlightedSlice == i ? highlightColor : colors[i % colors.length];
      paint.style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      paint.color = const Color(0XFF2e2e2e);
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
    paint.color = centerHighlighted ? highlightColor : colors[0];
    canvas.drawCircle(center, innerRadius, paint);

    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0XFF2e2e2e);
    paint.strokeWidth = 2;
    canvas.drawCircle(center, innerRadius, paint);
  }

  @override
  bool shouldRepaint(_DPadPainter oldDelegate) {
    return oldDelegate.highlightedSlice != highlightedSlice ||
        oldDelegate.centerHighlighted != centerHighlighted ||
        oldDelegate.highlightColor != highlightColor;
  }
}
