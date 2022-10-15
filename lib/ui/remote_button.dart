import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final double size;

  const RemoteButton({
    Key? key,
    this.size = 48,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final BoxDecoration _defaultStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
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

  final BoxDecoration _pressedStyle = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
    boxShadow: [
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
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0.0, 0.0),
        blurRadius: 1.0,
      ),
      BoxShadow(
        color: Color.fromRGBO(12, 12, 12, 1),
        offset: Offset(0.0, 0.0),
        blurRadius: 1.0,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return RemoteTap(
      width: size,
      height: size,
      defaultStyle: _defaultStyle,
      pressedStyle: _pressedStyle,
      onPressed: onPressed,
      child: child,
    );
  }
}
