import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const RemoteButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

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

  final BoxDecoration _pressedStyle = const BoxDecoration(
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

  @override
  Widget build(BuildContext context) {
    return RemoteTap(
      onPressed: onPressed,
      width: 37,
      height: 37,
      defaultStyle: _defaultStyle,
      pressedStyle: _pressedStyle,
      child: child,
    );
  }
}
