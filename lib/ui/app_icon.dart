import 'package:flutter/material.dart';
import 'package:remote/types/tv_app.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.app,
  });

  final TvApp app;
  final appIconsPath = 'assets/icons';

  @override
  Widget build(BuildContext context) {
    final icon = app.icon;
    final path = '$appIconsPath/$icon';

    return Image.asset(
      width: 120,
      height: 120,
      path,
      fit: BoxFit.cover,
    );
  }
}
