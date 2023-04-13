import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheet/route.dart';
import 'ui/remote.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const RemoteControllerApp());

  if (Platform.isMacOS || Platform.isLinux) {
    doWhenWindowReady(() {
      final win = appWindow;
      // doesn't work properly with a scaled resolution on Linux
      const initialSize = Size(320, 680);
      win.minSize = initialSize;
      // win.maxSize = initialSize;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remote',
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
    );
  }
}

class RemotePanel extends StatefulWidget {
  const RemotePanel({super.key});

  @override
  RemotePanelState createState() => RemotePanelState();
}

class RemotePanelState extends State<RemotePanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(46, 46, 46, 1),
      child: const SafeArea(
        child: Remote(),
      ),
    );
  }
}
