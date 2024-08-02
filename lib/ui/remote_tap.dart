import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RemoteTap extends StatefulWidget {
  final double width;
  final double height;
  final void Function() onPressed;
  final BoxDecoration style;
  final Color startColor = const Color.fromRGBO(73, 73, 73, 1);
  final Color endColor = const Color.fromRGBO(255, 152, 0, 1);
  final Widget child;

  const RemoteTap({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    this.style = const BoxDecoration(),
    this.child = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  State<RemoteTap> createState() => _RemoteTapState();
}

class _RemoteTapState extends State<RemoteTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );

    final startColor = widget.style.color ?? widget.startColor;
    final endColor = widget.style.color ?? widget.endColor;

    _colorTween = ColorTween(
      begin: startColor,
      end: endColor,
    ).animate(_controller);
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.duration = const Duration(milliseconds: 20);
    _controller.stop();
    _controller.forward();

    // TODO: settings
    HapticFeedback.mediumImpact();

    widget.onPressed();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.duration = const Duration(milliseconds: 480);

    Future.delayed(const Duration(milliseconds: 20), () {
      _controller.stop();
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      child: AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) {
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: widget.style.copyWith(
                color: _colorTween.value,
              ),
              child: widget.child,
            );
          }),
    );
  }
}
