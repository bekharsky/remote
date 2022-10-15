import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RemoteTap extends StatefulWidget {
  final double width;
  final double height;
  final void Function() onPressed;
  final BoxDecoration defaultStyle;
  final BoxDecoration pressedStyle;
  final Widget child;

  const RemoteTap({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    this.defaultStyle = const BoxDecoration(),
    this.pressedStyle = const BoxDecoration(),
    this.child = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  State<RemoteTap> createState() => _RemoteTapState();
}

class _RemoteTapState extends State<RemoteTap> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });

    // TODO: settings
    HapticFeedback.mediumImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });

    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: _pressed ? widget.pressedStyle : widget.defaultStyle,
        child: widget.child,
      ),
    );
  }
}
