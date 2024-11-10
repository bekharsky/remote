import 'package:flutter/widgets.dart';

class RemoteTap extends StatefulWidget {
  final double width;
  final double height;
  final void Function() onPressed;
  final BoxDecoration style;
  final Color startColor;
  final Color activeColor;
  final Widget child;

  const RemoteTap({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    this.startColor = const Color.fromRGBO(73, 73, 73, 1),
    this.activeColor = const Color.fromRGBO(255, 152, 0, 1),
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
  late Color _currentColor;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();

    _currentColor = widget.startColor;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _colorTween = ColorTween(
      begin: widget.activeColor,
      end: widget.startColor,
    ).animate(_controller);

    _colorTween.addListener(() {
      setState(() {
        _currentColor = _colorTween.value!;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentColor = widget.startColor;
        });
      }
    });
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.stop();

    setState(() {
      _currentColor = widget.activeColor;
      _isTapped = true;
    });

    widget.onPressed();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.forward(from: 0);
  }

  void _resetHighlight() {
    setState(() {
      _currentColor = widget.startColor;
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _resetHighlight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: widget.style.copyWith(
              color: _isTapped
                  ? _currentColor
                  : _controller.isAnimating
                      ? _colorTween.value
                      : _currentColor,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
