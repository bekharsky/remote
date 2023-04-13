import 'package:flutter/widgets.dart';

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
            Color color = i <= level
                ? const Color.fromRGBO(255, 152, 0, 1)
                : const Color.fromRGBO(0, 0, 0, 1);

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
