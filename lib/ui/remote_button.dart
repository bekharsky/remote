import 'package:flutter/widgets.dart';

class RemoteButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  const RemoteButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Color(0XFF2e2e2e),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [Color(0XFF1c1c1c), Color(0XFF383838)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0XFF1c1c1c),
              offset: Offset(5.0, 5.0),
              blurRadius: 10.0,
            ),
            BoxShadow(
              color: Color(0XFF404040),
              offset: Offset(-5.0, -5.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [Color(0XFF303030), Color(0XFF1a1a1a)]),
              ),
              child: child,
            ),
          ),
        ));
  }
}
