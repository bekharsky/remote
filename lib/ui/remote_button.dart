import 'package:flutter/widgets.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final double size;

  const RemoteButton({
    super.key,
    this.size = 48,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RemoteTap(
      width: size,
      height: size,
      style: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9999)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
