import 'dart:io';
import 'dart:developer';
import 'package:sheet/route.dart';
import 'package:flutter/widgets.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_level.dart';
import 'package:remote/ui/remote_ring.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_settings.dart';
import 'package:remote/ui/remote_tap.dart';

import '../key_codes.dart';
import '../types/tv.dart';

class Remote extends StatelessWidget {
  final void Function(Tv) onTvSelectCallback;
  final void Function(KeyCode) onButtonPressCallback;
  const Remote({
    super.key,
    required this.onTvSelectCallback,
    required this.onButtonPressCallback,
  });

  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final double _ringSize = _isMobile ? 220 : 166;
  static final double _buttonSize = _isMobile ? 64 : 48;
  static final double _powerButtonSize = _isMobile ? 48 : 36;
  static final double _powerPad = (_buttonSize - _powerButtonSize) / 2;
  static final double _hPad = _isMobile ? 48 : 30;
  static final double _vPad = _isMobile ? 48 : 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0XFF2e2e2e),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
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
                        onPressed: () {
                          onButtonPressCallback(KeyCode.KEY_POWER);
                          // onButtonPressCallback(KeyCode.KEY_POWEROFF);
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
                        onPressed: () {
                          log('Settings button pressed');
                          Navigator.of(context).push(
                            CupertinoSheetRoute<void>(
                              builder: (BuildContext context) {
                                return RemoteSettings(
                                  onTapCallback: onTvSelectCallback,
                                );
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
                      onPressed: () {
                        log('123 button pressed');
                        // TODO: find the key code
                        // onButtonPressCallback(KeyCode.KEY_);
                      },
                      child: RemoteIcons.num,
                    ),
                    RemoteButton(
                      size: _buttonSize,
                      onPressed: () {
                        log('ABC button pressed');
                        // TODO: find the key code
                        // onButtonPressCallback(KeyCode.KEY_);
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
                      onPressedUp: () {
                        onButtonPressCallback(KeyCode.KEY_UP);
                      },
                      onPressedRight: () {
                        onButtonPressCallback(KeyCode.KEY_RIGHT);
                      },
                      onPressedBottom: () {
                        onButtonPressCallback(KeyCode.KEY_DOWN);
                      },
                      onPressedLeft: () {
                        onButtonPressCallback(KeyCode.KEY_LEFT);
                      },
                      onPressedCenter: () {
                        // TODO what is the key?
                        // onButtonPressCallback(KeyCode.KEY_OPEN);
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
                      onPressed: () {
                        onButtonPressCallback(KeyCode.KEY_RETURN);
                      },
                      child: RemoteIcons.back,
                    ),
                    RemoteButton(
                      size: _buttonSize,
                      onPressed: () {
                        // TODO: detect play state
                        onButtonPressCallback(KeyCode.KEY_PLAY);
                        // onButtonPressCallback(KeyCode.KEY_PAUSE);
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
                      onPressed: () {
                        onButtonPressCallback(KeyCode.KEY_HOME);
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
                      onPressedLower: () {
                        onButtonPressCallback(KeyCode.KEY_VOLDOWN);
                      },
                      onPressedHigher: () {
                        onButtonPressCallback(KeyCode.KEY_VOLUP);
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
