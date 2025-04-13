import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:remote/services/commander.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/types/tv.dart';
import 'package:remote/types/tv_app.dart';
import 'package:remote/ui/remote_apps.dart';
import 'package:remote/ui/remote_sheet.dart';
import 'package:remote/ui/remote_tv_name.dart';
import 'package:remote/ui/window_title_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemotePanel extends StatefulWidget {
  const RemotePanel({super.key});

  @override
  RemotePanelState createState() => RemotePanelState();
}

class RemotePanelState extends State<RemotePanel> {
  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final bool _isMac = Platform.isMacOS;
  static const appName = 'TV Remote';
  // TODO: why passing this fails on invalid const in the sheet?
  static const List<double> sheetStops = [570, 430];
  EdgeInsets appsListShift = const EdgeInsets.only(top: 16);
  double shift = 1;
  Commander? commander;
  SharedPreferences? prefs;
  String name = '';
  String modelName = '';
  String? host;
  String? mac;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs?.getString('name') ?? 'Connect TV';
      modelName = prefs?.getString('modelName') ?? 'Click on the TV icon';
      host = prefs?.getString('host') ?? '';
      mac = prefs?.getString('mac') ?? '';
    });

    commander = Commander(
      name: appName,
      host: host,
      token: prefs?.getString('token') ?? '',
      onTokenUpdate: (newToken) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', newToken);
        });
      },
    );
  }

  onTvSelectCallback(ConnectedTv tv) async {
    setState(() {
      name = tv.name;
      modelName = tv.modelName;
      host = tv.ip;
      mac = tv.wifiMac;
    });

    final token = await commander?.reconnect();

    prefs?.setString('name', tv.name);
    prefs?.setString('modelName', tv.modelName);
    prefs?.setString('host', tv.ip);
    prefs?.setString('token', token ?? '');
    prefs?.setString('mac', mac ?? '');
  }

  void onKeyCallback(KeyCode keyCode) {
    commander?.sendKey(keyCode);
  }

  Future<List<TvApp>> onLoadAppsCallback() {
    return commander!.getAppsWithIcons();
  }

  void onLaunchAppCallback(String appId) {
    commander?.launchApp(appId);
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
          alignment: Alignment.center,
          color: theme.colors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isMobile) ...[WindowTitleBar(isMac: _isMac)],
              RemoteTvName(name: name, model: modelName),
              Container(
                padding: appsListShift,
                child: Opacity(
                  opacity: 1 - shift,
                  child: commander == null
                      ? null
                      : RemoteApps(
                          loadApps: onLoadAppsCallback,
                          launchApp: onLaunchAppCallback,
                        ),
                ),
              )
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
