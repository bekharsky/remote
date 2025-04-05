import 'package:flutter/material.dart';

class AppDragIcon extends StatelessWidget {
  const AppDragIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.white38,
        BlendMode.srcATop,
      ),
      child: Icon(
        Icons.drag_indicator,
        size: 16,
        color: Colors.black,
      ),
    );
  }
}
