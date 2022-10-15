import 'dart:developer';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_level.dart';
import 'package:remote/ui/remote_ring.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_settings.dart';
import 'package:remote/ui/remote_tap.dart';
import 'package:sheet/route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(RemoteControllerApp());

  if (Platform.isMacOS) {
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
  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final bool _isMac = Platform.isMacOS;
  static final double _ringSize = _isMobile ? 220 : 166;
  static final double _buttonSize = _isMobile ? 64 : 48;
  static final double _powerButtonSize = _isMobile ? 48 : 36;
  static final double _powerPad = (_buttonSize - _powerButtonSize) / 2;
  static final double _hPad = _isMobile ? 48 : 30;
  static final double _vPad = _isMobile ? 48 : 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        backgroundColor: Color(0XFF2e2e2e),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(_hPad, 0, _hPad, _vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: _isMobile ? _powerPad : _buttonSize,
                  child: _isMac ? MoveWindow() : const SizedBox.shrink(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: _powerPad,
                      ),
                      child: RemoteButton(
                        size: _powerButtonSize,
                        onPressed: () async {
                          log('Power button pressed');
                        },
                        child: RemoteIcons.power,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: _powerPad,
                      ),
                      child: RemoteTap(
                        width: _powerButtonSize,
                        height: _powerButtonSize,
                        onPressed: () async {
                          log('Settings button pressed');
                          Navigator.of(context).push(
                            CupertinoSheetRoute<void>(
                              builder: (BuildContext context) {
                                return const RemoteSettings();
                              },
                            ),
                          );
                        },
                        child: RemoteIcons.settings,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _powerButtonSize * (_isMobile ? 2 : 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RemoteButton(
                      size: _buttonSize,
                      onPressed: () async {
                        log('123 button pressed');
                      },
                      child: RemoteIcons.num,
                    ),
                    RemoteButton(
                      size: _buttonSize,
                      onPressed: () async {
                        log('ABC button pressed');
                      },
                      child: RemoteIcons.abc,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RemoteRing(
                      size: _ringSize,
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
                      size: _buttonSize,
                      onPressed: () async {
                        log('Back button pressed');
                      },
                      child: RemoteIcons.back,
                    ),
                    RemoteButton(
                      size: _buttonSize,
                      onPressed: () async {
                        log('Play button pressed');
                      },
                      child: RemoteIcons.play,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RemoteButton(
                      size: _buttonSize,
                      onPressed: () async {
                        log('Home button pressed');
                      },
                      child: RemoteIcons.home,
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
                      size: _ringSize,
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
        ),
      ),
    );
  }
}
