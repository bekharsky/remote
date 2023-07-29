import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote/services/commander.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/types/tv.dart';
import 'package:remote/ui/remote_sheet.dart';
import 'package:sheet/route.dart';
import 'ui/window_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static final double _buttonSize = _isMobile ? 64 : 48;
  late Commander commander;
  final appName = 'TV Remote';
  SharedPreferences? prefs;
  String name = 'Connect TV';
  String modelName = '';
  String? token;
  String? host;

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs?.getString('name') ?? '';
      modelName = prefs?.getString('modelName') ?? '';
      token = prefs?.getString('token') ?? '';
      host = prefs?.getString('host') ?? '';
    });

    commander = Commander(name: appName, host: host, token: token);
  }

  onTvSelectCallback(Tv tv) async {
    setState(() {
      name = tv.name;
      modelName = tv.modelName;
      host = tv.ip;
    });

    commander = Commander(name: appName, host: host);
    token = await commander.fetchToken();

    prefs?.setString('name', tv.name);
    prefs?.setString('modelName', tv.modelName);
    prefs?.setString('host', tv.ip);
    prefs?.setString('token', token ?? '');
  }

  onPressedCallback(KeyCode keyCode) {
    commander.sendKey(keyCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(73, 73, 73, 1),
      body: Stack(
        children: <Widget>[
          Container(
            //    color: Colors.,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: _buttonSize,
                        child: MoveWindow(
                          onDoubleTap: () => {},
                        ),
                      ),
                    ),
                    _isMac ? Container() : const WindowButtons(),
                  ],
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                Text(
                  modelName,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ],
            ),
          ),
          RemoteSheet(
            onTvSelectCallback: onTvSelectCallback,
            onPressedCallback: onPressedCallback,
          ),
        ],
      ),
    );
    // return Container(
    //   color: const Color.fromRGBO(46, 46, 46, 1),
    //   child: const SafeArea(
    //     child: Remote(),
    //   ),
    // );
  }
}
