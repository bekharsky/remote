import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:remote/types/key_codes.dart';
import 'dart:io';
import 'dart:developer';
import 'package:sheet/route.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_level.dart';
import 'package:remote/ui/remote_ring.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_tv_list.dart';
import 'package:remote/ui/remote_tap.dart';
import 'package:sheet/sheet.dart';
import '../types/tv.dart';

class RemoteSheet extends StatefulWidget {
  final void Function(Tv) onTvSelectCallback;
  final void Function(KeyCode) onPressedCallback;
  const RemoteSheet({
    Key? key,
    required this.onTvSelectCallback,
    required this.onPressedCallback,
  }) : super(key: key);

  @override
  RemoteSheetState createState() => RemoteSheetState();
}

class RemoteSheetState extends State<RemoteSheet> {
  final SheetController controller = SheetController();
  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final double _ringSize = _isMobile ? 220 : 180;
  static final double _buttonSize = _isMobile ? 64 : 48;
  static final double _powerButtonSize = _isMobile ? 48 : 36;
  static final double _powerPad = (_buttonSize - _powerButtonSize) / 2;
  static final double _hPad = _isMobile ? 48 : 24;
  static final double _vPad = _isMobile ? 24 : 16;

  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 400), animateSheet);
    super.initState();
  }

  void animateSheet() {
    controller.relativeAnimateTo(
      0.85,
      duration: const Duration(milliseconds: 400),
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
    return Sheet(
      physics: const SnapSheetPhysics(
        stops: <double>[0.6, 0.85],
        parent: BouncingSheetPhysics(),
      ),
      controller: controller,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0XFF2e2e2e),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: Container(
                  height: 4,
                  width: 56,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(73, 73, 73, 1),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ]),
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
                            log('Power button pressed');
                            widget.onPressedCallback(KeyCode.KEY_POWER);
                            // TODO: not all TVs support power toggle
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
                          child: RemoteIcons.tv,
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
                          log('Play button pressed');
                          widget.onPressedCallback(KeyCode.KEY_PLAY);
                        },
                        child: RemoteIcons.play,
                      ),
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          log('Pause button pressed');
                          // TODO: detect play state
                          widget.onPressedCallback(KeyCode.KEY_PAUSE);
                        },
                        child: RemoteIcons.pause,
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
                          log('Up button pressed');
                          widget.onPressedCallback(KeyCode.KEY_UP);
                        },
                        onPressedRight: () {
                          log('Right button pressed');
                          widget.onPressedCallback(KeyCode.KEY_RIGHT);
                        },
                        onPressedDown: () {
                          log('Down button pressed');
                          widget.onPressedCallback(KeyCode.KEY_DOWN);
                        },
                        onPressedLeft: () {
                          log('Left button pressed');
                          widget.onPressedCallback(KeyCode.KEY_LEFT);
                        },
                        onPressedCenter: () {
                          log('Center aka enter button pressed');
                          widget.onPressedCallback(KeyCode.KEY_ENTER);
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
                          log('Back aka return button pressed');
                          widget.onPressedCallback(KeyCode.KEY_RETURN);
                        },
                        child: RemoteIcons.back,
                      ),
                      RemoteButton(
                        size: _buttonSize,
                        onPressed: () {
                          log('123 button pressed');
                          // widget.onPressedCallback(KeyCode.KEY_PLAY);
                        },
                        child: RemoteIcons.num,
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
                          widget.onPressedCallback(KeyCode.KEY_HOME);
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
                        // TODO: detect current volume
                        size: _ringSize,
                        onPressedLower: () {
                          log('Volume down button pressed');
                          widget.onPressedCallback(KeyCode.KEY_VOLDOWN);
                        },
                        onPressedHigher: () {
                          log('Volume up button pressed');
                          widget.onPressedCallback(KeyCode.KEY_VOLUP);
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
