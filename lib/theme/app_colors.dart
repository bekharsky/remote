import 'dart:ui';

class AppColors {
  final Color primary;
  final Color active;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onBackground;
  final Color onSurface;

  const AppColors({
    required this.primary,
    required this.active,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onBackground,
    required this.onSurface,
  });
}

// Example instance
const remoteColors = AppColors(
  primary: Color.fromRGBO(73, 73, 73, 1),
  active: Color.fromRGBO(255, 152, 0, 1),
  background: Color.fromRGBO(46, 46, 46, 1),
  surface: Color.fromRGBO(73, 73, 73, 1),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onBackground: Color(0xFFFFFFFF),
  onSurface: Color(0xFFFFFFFF),
);
