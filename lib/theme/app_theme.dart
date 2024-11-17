import 'package:flutter/widgets.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme extends InheritedWidget {
  final AppColors colors;
  final AppTextStyles textStyles;

  const AppTheme({
    Key? key,
    required this.colors,
    required this.textStyles,
    required Widget child,
  }) : super(child: child, key: key);

  static AppTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTheme>()!;
  }

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return colors != oldWidget.colors || textStyles != oldWidget.textStyles;
  }
}
