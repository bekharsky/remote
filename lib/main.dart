import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote/services/commander.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/types/tv.dart';
import 'package:remote/types/tv_app.dart';
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

  // TODO: separate this to a different widget
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
  final appName = 'TV Remote';
  final appsConfig = 'assets/apps.json';
  final appIconsPath = 'assets/icons';
  late Commander commander;
  SharedPreferences? prefs;
  String name = '';
  String modelName = '';
  String? token;
  String? host;
  String? mac;
  List<TvApp> apps = [];

  @override
  void initState() {
    super.initState();
    initPrefs();
    initApps();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs?.getString('name') ?? 'Connect TV';
      modelName = prefs?.getString('modelName') ?? 'Click on the TV icon';
      token = prefs?.getString('token') ?? '';
      host = prefs?.getString('host') ?? '';
      mac = prefs?.getString('mac') ?? '';
    });

    // TODO: state?
    commander = Commander(name: appName, host: host, token: token);
  }

  Future<void> initApps() async {
    final config = await DefaultAssetBundle.of(context).loadString(appsConfig);
    final List<dynamic> data = jsonDecode(config);

    setState(() {
      apps = data
          .map((json) => TvApp.fromJson(json))
          .where((app) => app.visible && app.orgs.isNotEmpty)
          .toList();
      apps.sort((a, b) => a.position.compareTo(b.position));
    });
  }

  onTvSelectCallback(ConnectedTv tv) async {
    setState(() {
      name = tv.name;
      modelName = tv.modelName;
      host = tv.ip;
      mac = tv.wifiMac;
    });

    commander = Commander(name: appName, host: host);
    token = await commander.fetchToken();

    // TODO: use SQLite
    prefs?.setString('name', tv.name);
    prefs?.setString('modelName', tv.modelName);
    prefs?.setString('host', tv.ip);
    prefs?.setString('token', token ?? '');
    prefs?.setString('mac', mac ?? '');
  }

  onKeyCallback(KeyCode keyCode) {
    commander.sendKey(keyCode);
  }

  onAppCallback(String appId) {
    commander.launchApp(appId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(73, 73, 73, 1),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TODO: separate this to a different widget
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        // TODO: detect proper height or move text to MoveWindow
                        height: 36,
                        child: MoveWindow(
                          onDoubleTap: () => {},
                        ),
                      ),
                    ),
                    _isMac ? Container() : const WindowButtons(),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        modelName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ReorderableList(
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }

                      setState(() {
                        // TODO: store positions in settings
                        final app = apps.removeAt(oldIndex);
                        apps.insert(newIndex, app);
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: apps.length,
                    itemBuilder: (BuildContext context, int index) {
                      final app = apps[index];
                      final id = app.orgs[0];
                      final icon = app.icon;
                      final path = '$appIconsPath/$icon';
                      final isLastItem = index == apps.length - 1;
                      EdgeInsets itemMargin = EdgeInsets.fromLTRB(
                        16,
                        0,
                        isLastItem ? 16 : 0,
                        0,
                      );

                      return ReorderableDragStartListener(
                        index: index,
                        key: ValueKey(app),
                        child: GestureDetector(
                          // TODO: scale on hover and on tap
                          onTap: () {
                            log('App launch: $id');
                            onAppCallback(id);
                          },
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: itemMargin,
                            child: Image.asset(
                              path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          RemoteSheet(
            onTvSelectCallback: onTvSelectCallback,
            onPressedCallback: onKeyCallback,
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
