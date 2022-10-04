import 'dart:developer';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const RemoteControllerApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(262, 450);
    win.minSize = initialSize;
    win.maxSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.show();
  });
}

class RemoteControllerApp extends StatelessWidget {
  const RemoteControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remote',
      home: Scaffold(
        backgroundColor: Color(0XFF2e2e2e),
        body: RemotePanel(),
      ),
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 63,
            child: MoveWindow(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RemoteButton(
                child: RemoteIcons.power,
                onPressed: () async {
                  log('Power button pressed');
                },
              ),
              RemoteButton(
                child: RemoteIcons.home,
                onPressed: () async {
                  log('Home button pressed');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
