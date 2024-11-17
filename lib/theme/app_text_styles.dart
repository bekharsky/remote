import 'package:flutter/widgets.dart';
import 'app_colors.dart';

class AppTextStyles {
  final TextStyle name;
  final TextStyle model;

  const AppTextStyles({
    required this.name,
    required this.model,
  });
}

final remoteTextStyles = AppTextStyles(
  name: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: remoteColors.onBackground,
  ),
  model: TextStyle(
    fontSize: 14,
    color: remoteColors.onBackground,
  ),
);
