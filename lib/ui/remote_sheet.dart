import 'package:flutter/material.dart';
import 'package:remote/theme/app_theme.dart';
// import 'package:flutter/widgets.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_dpad.dart';
import 'package:remote/ui/remote_media_controls.dart';
import 'package:remote/ui/remote_sheet_toggle.dart';
import 'dart:io';
import 'dart:developer';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_tap.dart';
import 'package:sheet/sheet.dart';

class RemoteSheet extends StatefulWidget {
  final void Function(KeyCode) onPressed;
  final void Function(double) onSheetShift;
  final VoidCallback onPowerPressed;
  final VoidCallback onTvListPressed;
  final allowSkip = false;

  const RemoteSheet({
    super.key,
    required this.onPressed,
    required this.onSheetShift,
    required this.onPowerPressed,
    required this.onTvListPressed,
  });

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
      widget.onSheetShift(offset);
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
      physics: const SnapSheetPhysics(
        relative: false,
        stops: [430, 570],
        parent: BouncingScrollPhysics(),
      ),
      controller: controller,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(_hPad, 0, _hPad, _vPad),
        decoration: BoxDecoration(
          color: theme.colors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            RemoteSheetToggle(onTap: toggleSheet),
            Padding(
              padding: EdgeInsets.fromLTRB(_powerPad, 0, _powerPad, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RemoteTap(
                    width: _powerButtonSize,
                    height: _powerButtonSize,
                    startColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    onPressed: widget.onPowerPressed,
                    child: RemoteIcons.power(),
                  ),
                  RemoteTap(
                    width: _powerButtonSize,
                    height: _powerButtonSize,
                    // TODO: how to override theme colors still?
                    startColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    onPressed: widget.onTvListPressed,
                    child: RemoteIcons.tv(),
                  ),
                ],
              ),
            ),
            SizedBox(height: _powerButtonSize / 2),
            RemoteMediaControls(
              allowSkip: widget.allowSkip,
              buttonSize: _buttonSize,
              spacing: _powerButtonSize / 2,
              onPressed: widget.onPressed,
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
                  widget.onPressed(keyCode);
                }
              },
              onCenterClick: () {
                log('${KeyCode.KEY_ENTER.name} button pressed');
                widget.onPressed(KeyCode.KEY_ENTER);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RemoteButton(
                  size: _buttonSize,
                  onPressed: () {
                    log('Back aka return button pressed');
                    widget.onPressed(KeyCode.KEY_RETURN);
                  },
                  child: RemoteIcons.back(iconColor),
                ),
                RemoteButton(
                  size: _buttonSize,
                  onPressed: () {
                    log('123 button pressed');
                    widget.onPressed(KeyCode.KEY_MORE);
                  },
                  child: RemoteIcons.num(iconColor),
                ),
              ],
            ),
            RemoteButton(
              size: _buttonSize,
              onPressed: () {
                widget.onPressed(KeyCode.KEY_HOME);
              },
              child: RemoteIcons.home(iconColor),
            ),
            SizedBox(height: _buttonSize / 2),
            // TODO: just pass onPressed
            RemoteRocker(
              onPressedVolumeUp: () {
                log('Volume up button pressed');
                widget.onPressed(KeyCode.KEY_VOLUP);
              },
              onPressedVolumeDown: () {
                log('Volume down button pressed');
                widget.onPressed(KeyCode.KEY_VOLDOWN);
              },
              onPressedVolumeMute: () {
                log('Volume mute button pressed');
                widget.onPressed(KeyCode.KEY_MUTE);
              },
              onPressedChannelUp: () {
                log('Next program button pressed');
                widget.onPressed(KeyCode.KEY_CHUP);
              },
              onPressedChannelDown: () {
                log('Next program button pressed');
                widget.onPressed(KeyCode.KEY_CHDOWN);
              },
            ),
          ],
        ),
      ),
    );
  }
}
