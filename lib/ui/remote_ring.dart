import 'package:flutter/widgets.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_icons.dart';

enum Pressed { up, right, bottom, left, center, none }

class RemoteRing extends StatefulWidget {
  final double size;
  final void Function() onPressedUp;
  final void Function() onPressedRight;
  final void Function() onPressedDown;
  final void Function() onPressedLeft;
  final void Function() onPressedCenter;

  const RemoteRing({
    Key? key,
    this.size = 180,
    required this.onPressedUp,
    required this.onPressedRight,
    required this.onPressedDown,
    required this.onPressedLeft,
    required this.onPressedCenter,
  }) : super(key: key);

  @override
  State<RemoteRing> createState() => RemoteRingState();
}

class RemoteRingState extends State<RemoteRing> {
  late final double _size = widget.size;
  late final double _centerDia = _size / 2;
  late final double _buttonSize = (_size - _centerDia) / 2;
  final BoxDecoration _ringDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: _ringDefaultStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RemoteButton(
                onPressed: widget.onPressedUp,
                size: _buttonSize,
                child: RemoteIcons.arrowUp,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RemoteButton(
                onPressed: widget.onPressedLeft,
                size: _buttonSize,
                child: RemoteIcons.arrowLeft,
              ),
              RemoteButton(
                onPressed: widget.onPressedCenter,
                size: _centerDia,
                child: Container(),
              ),
              RemoteButton(
                onPressed: widget.onPressedRight,
                size: _buttonSize,
                child: RemoteIcons.arrowRight,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RemoteButton(
                onPressed: widget.onPressedDown,
                size: _buttonSize,
                child: RemoteIcons.arrowBottom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
