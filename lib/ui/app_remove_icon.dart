import 'package:flutter/material.dart';

class AppRemoveIcon extends StatelessWidget {
  const AppRemoveIcon({
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
        Icons.close,
        size: 16,
        color: Colors.black,
      ),
    );
  }
}
