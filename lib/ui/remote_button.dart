import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class RemoteButton extends StatefulWidget {
  final Widget child;
  final void Function() onPressed;
  const RemoteButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<RemoteButton> createState() => _RemoteButtonState();
}

class _RemoteButtonState extends State<RemoteButton> {
  bool _active = false;

  final BoxDecoration _defaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(37)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 4.0),
        blurRadius: 4.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(-2.0, 0.0),
        blurRadius: 3.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(2, 2, 2, 0.34),
        offset: Offset(5.0, 0.0),
        blurRadius: 9.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(101, 101, 101, 0.25),
        offset: Offset(-1.0, 0.0),
        blurRadius: 1.0,
        inset: true,
      ),
    ],
  );

  final BoxDecoration _activeStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(37)),
    color: Color.fromRGBO(44, 44, 44, 1),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 4.0),
        blurRadius: 4.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.4),
        offset: Offset(-7.0, 0.0),
        blurRadius: 7.0,
        spreadRadius: -1.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(224, 224, 224, 0.25),
        offset: Offset(1.0, 0.0),
        blurRadius: 1.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.36),
        offset: Offset(-6.0, 0.0),
        blurRadius: 6.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(255, 255, 255, 0.15),
        offset: Offset(3.0, 0.0),
        blurRadius: 6.0,
        spreadRadius: -1.0,
        inset: true,
      ),
    ],
  );

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _active = true;
    });

    widget.onPressed();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _active = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        child: Container(
          width: 37,
          height: 37,
          decoration: _active ? _activeStyle : _defaultStyle,
          child: widget.child,
        ));
  }
}
