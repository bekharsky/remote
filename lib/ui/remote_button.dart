import 'package:flutter/widgets.dart';
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

  final BoxDecoration _style = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
    color: Color.fromRGBO(73, 73, 73, 1),
  );

  @override
  Widget build(BuildContext context) {
    return RemoteTap(
      width: size,
      height: size,
      style: _style,
      onPressed: onPressed,
      child: child,
    );
  }
}
