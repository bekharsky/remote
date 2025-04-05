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
    if (app.iconBytes != null && app.iconBytes!.isNotEmpty) {
      return Image.memory(
        app.iconBytes!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      print('Icon bytes are null or empty!');
      return Container(); // Показать пустой контейнер, если нет иконки
    }
  }
}
