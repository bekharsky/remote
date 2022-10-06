import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:remote/ui/remote_icons.dart';

class RemoteRing extends StatefulWidget {
  final void Function() onPressedUp;
  final void Function() onPressedRight;
  final void Function() onPressedDown;
  final void Function() onPressedLeft;
  final void Function() onPressedCenter;

  const RemoteRing({
    Key? key,
    required this.onPressedUp,
    required this.onPressedRight,
    required this.onPressedDown,
    required this.onPressedLeft,
    required this.onPressedCenter,
  }) : super(key: key);

  @override
  State<RemoteRing> createState() => _RemoteRingState();
}

class _RemoteRingState extends State<RemoteRing> {
  // bool _pressed = false;

  static const double _ringDia = 166;
  static const double _centerDia = 86;
  static const double _buttonSize = (_ringDia - _centerDia) / 2;

  final BoxDecoration _ringDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(_ringDia)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(-3.0, 0.0),
        blurRadius: 3.0,
      ),
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
    ],
  );

  final BoxDecoration _centerDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(_centerDia)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(-25.0, 0.0),
        blurRadius: 27.0,
        inset: true,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 1),
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

  // void _handleTapDown(TapDownDetails details) {
  //   setState(() {
  //     _pressed = true;
  //   });
  // }

  // void _handleTapUp(TapUpDetails details) {
  //   setState(() {
  //     _pressed = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _ringDia,
      height: _ringDia,
      decoration: _ringDefaultStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: _buttonSize,
                height: _buttonSize,
                child: RemoteIcons.arrowUp,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: _buttonSize,
                height: _buttonSize,
                child: RemoteIcons.arrowLeft,
              ),
              Container(
                  width: _centerDia,
                  height: _centerDia,
                  decoration: _centerDefaultStyle),
              const SizedBox(
                width: _buttonSize,
                height: _buttonSize,
                child: RemoteIcons.arrowRight,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: _buttonSize,
                height: _buttonSize,
                child: RemoteIcons.arrowBottom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
