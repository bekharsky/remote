import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remote/services/soap_upnp.dart';
import 'package:remote/services/wake_on_lan.dart';
import 'package:remote/theme/app_theme.dart';
// import 'package:flutter/widgets.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_dpad.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:developer';
import 'package:sheet/route.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_tv_list.dart';
import 'package:remote/ui/remote_tap.dart';
import 'package:sheet/sheet.dart';
import 'package:remote/types/tv.dart';

class RemoteSheet extends StatefulWidget {
  final void Function(ConnectedTv) onTvSelectCallback;
  final void Function(KeyCode) onPressedCallback;
  final void Function(double) onSheetShiftCallback;

  const RemoteSheet({
    Key? key,
    required this.onTvSelectCallback,
    required this.onPressedCallback,
    required this.onSheetShiftCallback,
  }) : super(key: key);

  @override
  RemoteSheetState createState() => RemoteSheetState();
}

class RemoteSheetState extends State<RemoteSheet> {
  final SheetController controller = SheetController();
  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final double _buttonSize = _isMobile ? 64 : 48;
  static final double _powerButtonSize = _isMobile ? 48 : 36;
  static final double _powerPad = (_buttonSize - _powerButtonSize) / 2;
  static final double _hPad = _isMobile ? 48 : 24;
  static final double _vPad = _isMobile ? 24 : 16;

  @override
  void initState() {
    controller.addListener(() {
      double offset = controller.offset;
      widget.onSheetShiftCallback(offset);
    });

    super.initState();
  }

  void toggleSheet([bool force = false]) {
    log('${controller.offset}');

    controller.animateTo(
      controller.offset == 430 || force ? 570 : 430,
      duration: const Duration(
        milliseconds: 400,
      ),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final iconColor = theme.colors.onPrimary;

    return Sheet(
      initialExtent: 570,
      minExtent: 430,
      maxExtent: 570,
      // TODO: allow sheet to bounce up just a bit
      physics: const SnapSheetPhysics(
        relative: false,
        stops: [430, 570],
        parent: BouncingScrollPhysics(),
      ),
      controller: controller,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: toggleSheet,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: 4,
                    width: 56,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(73, 73, 73, 1),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(_hPad, 0, _hPad, _vPad),
              child: Column(
                spacing: 4,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: _powerPad,
                        ),
                        child: RemoteTap(
                          width: _powerButtonSize,
                          height: _powerButtonSize,
                          startColor: Colors.transparent,
                          activeColor: Colors.transparent,
                          onPressed: () async {
                            log('Power button pressed');
                            final prefs = await SharedPreferences.getInstance();
                            final host = prefs.getString('host') ?? '';
                            final mac = prefs.getString('mac') ?? '';
                            const timeout = Duration(milliseconds: 500);

                            final timer = Timer(timeout, () {
                              WakeOnLan(mac).wake();
                            });

                            try {
                              await SoapUpnp(host).getVolume();
                              timer.cancel();
                            } catch (e) {
                              log(e.toString());
                            } finally {
                              widget.onPressedCallback(KeyCode.KEY_POWER);
                            }
                          },
                          child: RemoteIcons.power(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: _powerPad,
                        ),
                        child: RemoteTap(
                          width: _powerButtonSize,
                          height: _powerButtonSize,
                          // TODO: how to override theme colors still?
                          startColor: Colors.transparent,
                          activeColor: Colors.transparent,
                          onPressed: () {
                            // TODO: move that to the main section/window frame
                            log('TV list button pressed');
                            Navigator.of(context).push(
                              CupertinoSheetRoute<void>(
                                builder: (BuildContext context) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: SheetMediaQuery(
                                      child: TvList(
                                        onTapCallback:
                                            widget.onTvSelectCallback,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: RemoteIcons.tv(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _powerButtonSize / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          log('Play button pressed');
                          widget.onPressedCallback(KeyCode.KEY_PLAY);
                        },
                        child: RemoteIcons.play(iconColor),
                      ),
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          log('Pause button pressed');
                          // TODO: detect play state
                          widget.onPressedCallback(KeyCode.KEY_PAUSE);
                        },
                        child: RemoteIcons.pause(iconColor),
                      ),
                    ],
                  ),
                  RemoteDPad(
                    size: 200.0,
                    colors: List.filled(4, theme.colors.primary),
                    icons: [
                      RemoteIcons.arrowRight(iconColor),
                      RemoteIcons.arrowBottom(iconColor),
                      RemoteIcons.arrowLeft(iconColor),
                      RemoteIcons.arrowUp(iconColor),
                    ],
                    activeColor: theme.colors.active,
                    onSliceClick: (index) {
                      log('Slice clicked: $index');

                      const keyCodeMap = {
                        0: KeyCode.KEY_RIGHT,
                        1: KeyCode.KEY_DOWN,
                        2: KeyCode.KEY_LEFT,
                        3: KeyCode.KEY_UP,
                      };

                      final keyCode = keyCodeMap[index];

                      if (keyCode != null) {
                        log('${keyCode.name} button pressed');
                        widget.onPressedCallback(keyCode);
                      }
                    },
                    onCenterClick: () {
                      log('${KeyCode.KEY_ENTER.name} button pressed');
                      widget.onPressedCallback(KeyCode.KEY_ENTER);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          log('Back aka return button pressed');
                          widget.onPressedCallback(KeyCode.KEY_RETURN);
                        },
                        child: RemoteIcons.back(iconColor),
                      ),
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          log('123 button pressed');
                          widget.onPressedCallback(KeyCode.KEY_DYNAMIC);
                        },
                        child: RemoteIcons.num(iconColor),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          widget.onPressedCallback(KeyCode.KEY_HOME);
                        },
                        child: RemoteIcons.home(iconColor),
                      ),
                    ],
                  ),
                  SizedBox(height: _buttonSize / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RemoteRocker(
                        onPressedVolumeUp: () {
                          log('Volume up button pressed');
                          widget.onPressedCallback(KeyCode.KEY_VOLUP);
                        },
                        onPressedVolumeDown: () {
                          log('Volume down button pressed');
                          widget.onPressedCallback(KeyCode.KEY_VOLDOWN);
                        },
                        onPressedVolumeMute: () {
                          log('Volume mute button pressed');
                          widget.onPressedCallback(KeyCode.KEY_MUTE);
                        },
                        onPressedChannelUp: () {
                          log('Next program button pressed');
                          widget.onPressedCallback(KeyCode.KEY_CHUP);
                        },
                        onPressedChannelDown: () {
                          log('Next program button pressed');
                          widget.onPressedCallback(KeyCode.KEY_CHDOWN);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
