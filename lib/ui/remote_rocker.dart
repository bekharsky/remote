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
  late final double _width = widget.size;
  late final double _height = _width / 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RemoteTap(
            onPressed: widget.onPressedLower,
            width: _width / 2,
            height: _height,
            style: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9999),
                  bottomLeft: Radius.circular(9999)),
            ),
            child: RemoteIcons.lower,
          ),
          RemoteTap(
            onPressed: widget.onPressedHigher,
            width: _width / 2,
            height: _height,
            style: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(9999),
                  bottomRight: Radius.circular(9999)),
            ),
            child: RemoteIcons.higher,
          ),
        ],
      ),
    );
  }
}
