import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteRocker extends StatefulWidget {
  final void Function() onPressedLower;
  final void Function() onPressedHigher;

  const RemoteRocker({
    Key? key,
    required this.onPressedLower,
    required this.onPressedHigher,
  }) : super(key: key);

  @override
  State<RemoteRocker> createState() => _RemoteRockerState();
}

class _RemoteRockerState extends State<RemoteRocker> {
  String _pressed = ''; // TODO: enum type

  static const double _width = 166;
  static const double _height = 35;
  static const List<BoxShadow> _baseShadow = [
    BoxShadow(
      color: Color.fromRGBO(109, 109, 109, 0.25),
      offset: Offset(1.0, 0.0),
      blurRadius: 2.0,
      inset: true,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      offset: Offset(84, 0.0),
      blurRadius: 33.0,
      inset: true,
    ),
  ];

  final BoxDecoration _rockerDefaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(_height)),
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

  final BoxDecoration _rockerPressedLowerStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(_height)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(1.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(1.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  final BoxDecoration _rockerPressedHigherStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(_height)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
      ..._baseShadow,
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(-1.0, 0.0),
        blurRadius: 2.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(-1.0, 0.0),
        blurRadius: 2.0,
      ),
    ],
  );

  void _handleTapDownLower(TapDownDetails details) {
    setState(() {
      _pressed = 'lower';
    });
  }

  void _handleTapUpLower(TapUpDetails details) {
    setState(() {
      _pressed = '';
    });
  }

  void _handleTapDownHigher(TapDownDetails details) {
    setState(() {
      _pressed = 'higher';
    });
  }

  void _handleTapUpHigher(TapUpDetails details) {
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
      width: _width,
      height: _height,
      decoration: _pressed == 'lower'
          ? _rockerPressedLowerStyle
          : _pressed == 'higher'
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
