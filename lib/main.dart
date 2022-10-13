import 'dart:developer';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_ring.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const RemoteControllerApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(262, 548);
    win.minSize = initialSize;
    // win.maxSize = initialSize;
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
          Platform.isMacOS
              ? SizedBox(
                  height: 63,
                  child: MoveWindow(),
                )
              : const SizedBox(
                  height: 30,
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RemoteRing(
              onPressedUp: () async {},
              onPressedRight: () async {},
              onPressedDown: () async {},
              onPressedLeft: () async {},
              onPressedCenter: () async {},
            )
          ]),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RemoteButton(
              child: RemoteIcons.voice,
              onPressed: () async {
                log('Voice button pressed');
              },
            ),
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RemoteButton(
              child: RemoteIcons.back,
              onPressed: () async {
                log('Back button pressed');
              },
            ),
            RemoteButton(
              child: RemoteIcons.ok,
              onPressed: () async {
                log('Ok button pressed');
              },
            ),
          ]),
        ],
      ),
    );
  }
}
