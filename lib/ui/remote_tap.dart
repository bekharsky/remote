import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class RemoteTap extends StatefulWidget {
  final double width;
  final double height;
  final BoxDecoration defaultStyle;
  final BoxDecoration pressedStyle;
  final void Function() onPressed;
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
    HapticFeedback.lightImpact();
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
          width: 37,
          height: 37,
          decoration: _pressed ? widget.pressedStyle : widget.defaultStyle,
          child: widget.child,
        ));
  }
}
