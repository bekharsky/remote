import 'package:flutter/cupertino.dart';

class RemoteAppsSkeleton extends StatelessWidget {
  const RemoteAppsSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of skeleton items
        itemBuilder: (context, index) {
          final itemMargin = EdgeInsets.only(
            left: index == 0 ? 12 : 0,
            right: 12,
          );

          return Container(
            margin: itemMargin,
            width: 120, // Approximate width of an app icon
            decoration: BoxDecoration(
              color: Color.fromRGBO(100, 100, 100, 1.0),
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
