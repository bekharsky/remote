import 'package:flutter/material.dart';

class RemoteButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final double size;
  final Color startColor = const Color.fromRGBO(73, 73, 73, 1);
  final Color endColor = const Color.fromRGBO(255, 152, 0, 1);

  RemoteButton({
    Key? key,
    this.size = 48,
    required this.child,
    required this.onPressed,
  });

  @override
  _ColorChangeButtonState createState() => _ColorChangeButtonState();
}

class _ColorChangeButtonState extends State<RemoteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _colorTween = ColorTween(begin: widget.startColor, end: widget.endColor)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 150), () {
          _controller.reverse();
        });
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              disabledForegroundColor: Colors.white,
              disabledBackgroundColor: _colorTween.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              padding: EdgeInsets.all(16),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// import 'package:flutter/widgets.dart';
// import 'package:remote/ui/remote_tap.dart';

// class RemoteButton extends StatelessWidget {
//   final Widget child;
//   final void Function() onPressed;
//   final double size;

//   const RemoteButton({
//     Key? key,
//     this.size = 48,
//     required this.onPressed,
//     required this.child,
//   }) : super(key: key);

//   final BoxDecoration _defaultStyle = const BoxDecoration(
//     borderRadius: BorderRadius.all(Radius.circular(9999)),
//     color: Color.fromRGBO(73, 73, 73, 1),
//   );

//   final BoxDecoration _pressedStyle = const BoxDecoration(
//     borderRadius: BorderRadius.all(Radius.circular(9999)),
//     color: Color.fromRGBO(255, 152, 0, 1),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return RemoteTap(
//       width: size,
//       height: size,
//       defaultStyle: _defaultStyle,
//       pressedStyle: _pressedStyle,
//       onPressed: onPressed,
//       child: child,
//     );
//   }
// }
