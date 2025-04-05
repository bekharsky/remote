import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:remote/services/commander.dart';
import 'package:remote/theme/app_colors.dart';
import 'package:remote/theme/app_text_styles.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/types/tv.dart';
import 'package:remote/types/tv_app.dart';
import 'package:remote/ui/remote_apps.dart';
import 'package:remote/ui/remote_scroll_behavior.dart';
import 'package:remote/ui/remote_sheet.dart';
import 'package:remote/ui/remote_tv_name.dart';
import 'package:remote/ui/window_title_bar.dart';
import 'package:sheet/route.dart';
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

class RemotePanel extends StatefulWidget {
  const RemotePanel({super.key});

  @override
  RemotePanelState createState() => RemotePanelState();
}

class RemotePanelState extends State<RemotePanel> {
  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final bool _isMac = Platform.isMacOS;
  static const appName = 'TV Remote';
  static const appsConfig = 'assets/apps.json';
  // TODO: why passing this fails on invalid const in the sheet?
  static const List<double> sheetStops = [570, 430];
  EdgeInsets appsListShift = const EdgeInsets.only(top: 16);
  double shift = 1;
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

    prefs?.setString('name', tv.name);
    prefs?.setString('modelName', tv.modelName);
    prefs?.setString('host', tv.ip);
    prefs?.setString('token', token ?? '');
    prefs?.setString('mac', mac ?? '');
  }

  void onKeyCallback(KeyCode keyCode) {
    commander.sendKey(keyCode);
  }

  Future<void> onAppCallback(String appId) async {
    log('App launch: $appId');
    // commander.launchApp(appId);
    // commander.getInstalledApps();
    final apps = await commander.getAppsWithIcons();

    for (var app in apps) {
      // ignore: avoid_print
      print(
          '${app.name} (${app.appId}) - icon size: ${app.iconBytes?.length ?? 0}');
    }
  }

  void onSheetShiftCallback(double offset) {
    final range = sheetStops[0] - sheetStops[1];
    final diff = offset - sheetStops[1];

    setState(() {
      shift = (diff / range).clamp(0, 1);
      appsListShift = EdgeInsets.only(top: shift * 24);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          color: theme.colors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!Platform.isAndroid && !Platform.isIOS) ...[
                WindowTitleBar(isMac: _isMac)
              ],
              RemoteTvName(name: name, model: modelName),
              if (apps.isNotEmpty) ...[
                Container(
                  padding: appsListShift,
                  child: Opacity(
                    opacity: 1 - shift,
                    child: RemoteApps(
                      apps: apps,
                      onAppCallback: onAppCallback,
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
        RemoteSheet(
          onTvSelectCallback: onTvSelectCallback,
          onPressedCallback: onKeyCallback,
          onSheetShiftCallback: onSheetShiftCallback,
        ),
      ],
    );
  }
}
