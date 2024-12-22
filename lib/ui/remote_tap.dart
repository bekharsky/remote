import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remote/theme/app_theme.dart';

class RemoteTap extends StatefulWidget {
  final double width;
  final double height;
  final void Function() onPressed;
  final BoxDecoration style;
  final Color? startColor;
  final Color? activeColor;
  final Widget child;

  const RemoteTap({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    this.style = const BoxDecoration(),
    this.child = const SizedBox.shrink(),
    this.startColor,
    this.activeColor,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theme = AppTheme.of(context);
      final startColor = widget.startColor ?? theme.colors.primary;
      final activeColor = widget.activeColor ?? theme.colors.active;

      _currentColor = startColor;

      _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      _colorTween = ColorTween(
        begin: activeColor,
        end: startColor,
      ).animate(_controller);

      _colorTween.addListener(() {
        setState(() {
          _currentColor = _colorTween.value!;
        });
      });

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentColor = startColor;
          });
        }
      });
    });
  }

  void _handleTapDown(BuildContext context, TapDownDetails details) {
    final theme = AppTheme.of(context);
    final activeColor = widget.activeColor ?? theme.colors.active;

    _controller.stop();

    setState(() {
      _currentColor = activeColor;
      _isTapped = true;
    });

    widget.onPressed();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.forward(from: 0);

    setState(() {
      _isTapped = false;
    });
  }

  void _resetHighlight(BuildContext context) {
    final theme = AppTheme.of(context);
    final startColor = widget.startColor ?? theme.colors.primary;

    setState(() {
      _currentColor = startColor;
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _handleTapDown(context, details),
      onTapUp: _handleTapUp,
      onTapCancel: () => _resetHighlight(context),
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
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentColor,
                _isTapped || _controller.value < 0.5
                    ? BlendMode.screen
                    : BlendMode.dst,
              ),
              child: widget.child,
            ),
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
