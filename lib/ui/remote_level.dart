import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide BoxDecoration, BoxShadow;

class RemoteLevel extends StatelessWidget {
  final int level;

  const RemoteLevel({
    Key? key,
    this.level = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Padding>.generate(10, (i) {
            Color color = i <= level ? Colors.orange : Colors.black;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
