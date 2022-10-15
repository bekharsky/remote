import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteRing extends StatefulWidget {
  final double size;
  final void Function() onPressedUp;
  final void Function() onPressedRight;
  final void Function() onPressedBottom;
  final void Function() onPressedLeft;
  final void Function() onPressedCenter;

  const RemoteRing({
    Key? key,
    this.size = 166,
    required this.onPressedUp,
    required this.onPressedRight,
    required this.onPressedBottom,
    required this.onPressedLeft,
    required this.onPressedCenter,
  }) : super(key: key);

  @override
  State<RemoteRing> createState() => _RemoteRingState();
}

class _RemoteRingState extends State<RemoteRing> {
  String _pressed = '';
  late final double _size = widget.size;
  late final double _centerDia = _size / 2;
  late final double _buttonSize = (_size - _centerDia) / 2;

  static const List<BoxShadow> _baseShadow = [
    BoxShadow(
      color: Color.fromRGBO(2, 2, 2, 0.34),
      offset: Offset(26.0, 0.0),
      blurRadius: 40.0,
      inset: true,
    ),
    BoxShadow(
      color: Color.fromRGBO(103, 103, 103, 0.25),
      offset: Offset(-1.0, 0.0),
      blurRadius: 3.0,
      inset: true,
    ),
    BoxShadow(
      color: Color.fromRGBO(167, 167, 167, 0.25),
      offset: Offset(-1.0, 0.0),
      blurRadius: 1.0,
      inset: true,
    ),
  ];

  final BoxDecoration _ringDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  final BoxDecoration _ringPressedTopStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  final BoxDecoration _ringPressedRightStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  final BoxDecoration _ringPressedBottomStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  final BoxDecoration _ringPressedLeftStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  final BoxDecoration _centerDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(-2.0, 0.0),
        blurRadius: 2.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        offset: Offset(-1.0, 0.0),
        blurRadius: 8.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 3.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        offset: Offset(2.0, 0.0),
        blurRadius: 1.0,
        inset: true,
      ),
    ],
  );

  final BoxDecoration _centerPressedStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(-2.0, 0.0),
        blurRadius: 2.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.65),
        offset: Offset(-1.0, 0.0),
        blurRadius: 8.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 3.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        offset: Offset(2.0, 0.0),
        blurRadius: 1.0,
        inset: true,
      ),
    ],
  );

  void _handleTapDownUp(TapDownDetails details) {
    setState(() {
      _pressed = 'up';
    });
  }

  void _handleTapUpUp(TapUpDetails details) {
    setState(() {
      _pressed = '';
    });
  }

  void _handleTapDownRight(TapDownDetails details) {
    setState(() {
      _pressed = 'right';
    });
  }

  void _handleTapUpRight(TapUpDetails details) {
    setState(() {
      _pressed = '';
    });
  }

  void _handleTapDownBottom(TapDownDetails details) {
    setState(() {
      _pressed = 'down';
    });
  }

  void _handleTapUpBottom(TapUpDetails details) {
    setState(() {
      _pressed = '';
    });
  }

  void _handleTapDownLeft(TapDownDetails details) {
    setState(() {
      _pressed = 'left';
    });
  }

  void _handleTapUpLeft(TapUpDetails details) {
    setState(() {
      _pressed = '';
    });
  }

  void _handleTapCancel() {
    setState(() {
      _pressed = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: _pressed == 'up'
          ? _ringPressedTopStyle
          : _pressed == 'right'
              ? _ringPressedRightStyle
              : _pressed == 'bottom'
                  ? _ringPressedBottomStyle
                  : _pressed == 'left'
                      ? _ringPressedLeftStyle
                      : _ringDefaultStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: _handleTapDownUp,
                onTapUp: _handleTapUpUp,
                onTapCancel: _handleTapCancel,
                child: RemoteTap(
                  onPressed: widget.onPressedUp,
                  width: _buttonSize,
                  height: _buttonSize,
                  child: RemoteIcons.arrowUp,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTapDown: _handleTapDownLeft,
                onTapUp: _handleTapUpLeft,
                onTapCancel: _handleTapCancel,
                child: RemoteTap(
                  onPressed: widget.onPressedLeft,
                  width: _buttonSize,
                  height: _buttonSize,
                  child: RemoteIcons.arrowLeft,
                ),
              ),
              RemoteTap(
                onPressed: widget.onPressedCenter,
                width: _centerDia,
                height: _centerDia,
                defaultStyle: _centerDefaultStyle,
                pressedStyle: _centerPressedStyle,
              ),
              GestureDetector(
                onTapDown: _handleTapDownRight,
                onTapUp: _handleTapUpRight,
                onTapCancel: _handleTapCancel,
                child: RemoteTap(
                  onPressed: widget.onPressedRight,
                  width: _buttonSize,
                  height: _buttonSize,
                  child: RemoteIcons.arrowRight,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: _handleTapDownBottom,
                onTapUp: _handleTapUpBottom,
                onTapCancel: _handleTapCancel,
                child: RemoteTap(
                  onPressed: widget.onPressedBottom,
                  width: _buttonSize,
                  height: _buttonSize,
                  child: RemoteIcons.arrowBottom,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
