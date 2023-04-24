import 'dart:io';
import 'dart:developer';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:sheet/route.dart';
import 'package:flutter/widgets.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_level.dart';
import 'package:remote/ui/remote_ring.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_settings.dart';
import 'package:remote/ui/remote_tap.dart';
import 'window_buttons.dart';

class Remote extends StatelessWidget {
  const Remote({
    super.key,
  });

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
    return Container(
      color: const Color(0XFF2e2e2e),
      child: Column(
        children: [
          // TODO: move to main widget
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
          Padding(
            padding: EdgeInsets.fromLTRB(_hPad, _vPad, _hPad, _vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
        ],
      ),
    );
  }
}
