import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:remote/theme/app_colors.dart';
import 'package:remote/theme/app_text_styles.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/ui/remote_panel.dart';
import 'package:remote/ui/remote_scroll_behavior.dart';
import 'package:sheet/route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const RemoteControllerApp());

  if (!Platform.isAndroid && !Platform.isIOS) {
    doWhenWindowReady(() {
      final win = appWindow;
      // doesn't work properly with a scaled resolution on Linux
      const initialSize = Size(320, 680);
      win.minSize = initialSize;
      win.maxSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.centerRight;
      win.show();
    });
  }
}

class RemoteControllerApp extends StatelessWidget {
  const RemoteControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      colors: remoteColors,
      textStyles: remoteTextStyles,
      child: ScrollConfiguration(
        behavior: RemoteScrollBehavior().copyWith(scrollbars: false),
        child: WidgetsApp(
          debugShowCheckedModeBanner: false,
          color: remoteColors.primary,
          title: 'TV Remote',
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == '/') {
              return MaterialExtendedPageRoute<void>(
                builder: (BuildContext context) {
                  return const RemotePanel();
                },
              );
            }

            return null;
          },
        ),
      ),
    );
  }
}
