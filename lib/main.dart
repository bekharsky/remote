import 'dart:developer';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_level.dart';
import 'package:remote/ui/remote_ring.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_tap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const RemoteControllerApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(280, 600);
    win.minSize = initialSize;
    // win.maxSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.centerRight;
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 48,
              child: Platform.isMacOS ? MoveWindow() : const SizedBox.shrink(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: RemoteButton(
                    size: 36,
                    onPressed: () async {
                      log('Power button pressed');
                    },
                    child: RemoteIcons.power,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: RemoteTap(
                    width: 36,
                    height: 36,
                    onPressed: () async {
                      log('Power button pressed');
                    },
                    child: RemoteIcons.settings,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RemoteButton(
                  child: RemoteIcons.num,
                  onPressed: () async {
                    log('123 button pressed');
                  },
                ),
                RemoteButton(
                  child: RemoteIcons.abc,
                  onPressed: () async {
                    log('ABC button pressed');
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteRing(
                  onPressedUp: () async {
                    log('Up button pressed');
                  },
                  onPressedRight: () async {
                    log('Right button pressed');
                  },
                  onPressedBottom: () async {
                    log('Bottom button pressed');
                  },
                  onPressedLeft: () async {
                    log('Left button pressed');
                  },
                  onPressedCenter: () async {
                    log('Center button pressed');
                  },
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RemoteButton(
                  child: RemoteIcons.back,
                  onPressed: () async {
                    log('Back button pressed');
                  },
                ),
                RemoteButton(
                  child: RemoteIcons.play,
                  onPressed: () async {
                    log('Play button pressed');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteButton(
                  child: RemoteIcons.home,
                  onPressed: () async {
                    log('Home button pressed');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const RemoteLevel(
              level: 5,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemoteRocker(
                  onPressedLower: () async {
                    log('Lower button pressed');
                  },
                  onPressedHigher: () async {
                    log('Higher button pressed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
