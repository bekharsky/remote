import 'package:flutter/widgets.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_tap.dart';

enum Pressed { lower, higher, none }

class RemoteRocker extends StatefulWidget {
  final double size;
  final void Function() onPressedLower;
  final void Function() onPressedHigher;

  const RemoteRocker({
    Key? key,
    this.size = 166,
    required this.onPressedLower,
    required this.onPressedHigher,
  }) : super(key: key);

  @override
  State<RemoteRocker> createState() => _RemoteRockerState();
}

class _RemoteRockerState extends State<RemoteRocker> {
  Pressed _pressed = Pressed.none;
  late final double _width = widget.size;
  late final double _height = _width / 5;

  final BoxDecoration _rockerDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
  );

  final BoxDecoration _rockerPressedLowerStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(255, 152, 0, 1),
  );

  final BoxDecoration _rockerPressedHigherStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(255, 152, 0, 1),
  );

  void _handleTapDownLower(TapDownDetails details) {
    setState(() {
      _pressed = Pressed.lower;
    });
  }

  void _handleTapUpLower(TapUpDetails details) {
    setState(() {
      _pressed = Pressed.none;
    });
  }

  void _handleTapDownHigher(TapDownDetails details) {
    setState(() {
      _pressed = Pressed.higher;
    });
  }

  void _handleTapUpHigher(TapUpDetails details) {
    setState(() {
      _pressed = Pressed.none;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _pressed = Pressed.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: _pressed == Pressed.lower
          ? _rockerPressedLowerStyle
          : _pressed == Pressed.higher
              ? _rockerPressedHigherStyle
              : _rockerDefaultStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTapDown: _handleTapDownLower,
                onTapUp: _handleTapUpLower,
                onTapCancel: _handleTapCancel,
                child: RemoteTap(
                  onPressed: widget.onPressedLower,
                  width: _height,
                  height: _height,
                  child: RemoteIcons.lower,
                ),
              ),
              GestureDetector(
                onTapDown: _handleTapDownHigher,
                onTapUp: _handleTapUpHigher,
                onTapCancel: _handleTapCancel,
                child: RemoteTap(
                  onPressed: widget.onPressedHigher,
                  width: _height,
                  height: _height,
                  child: RemoteIcons.higher,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
