import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_dpad.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_media_controls.dart';
import 'package:remote/ui/remote_rocker.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteControls extends StatelessWidget {
  final void Function(KeyCode) onPressed;
  final VoidCallback onPowerPressed;
  final VoidCallback onTvListPressed;
  final bool allowSkip;

  const RemoteControls({
    super.key,
    required this.onPressed,
    required this.onPowerPressed,
    required this.onTvListPressed,
    this.allowSkip = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final iconColor = theme.colors.onPrimary;

    final bool isMobile = Platform.isIOS || Platform.isAndroid;
    final double buttonSize = isMobile ? 64 : 48;
    final double powerButtonSize = isMobile ? 48 : 36;
    final double powerPad = (buttonSize - powerButtonSize) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(powerPad, 0, powerPad, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RemoteTap(
                width: powerButtonSize,
                height: powerButtonSize,
                startColor: Colors.transparent,
                activeColor: Colors.transparent,
                onPressed: onPowerPressed,
                child: RemoteIcons.power(),
              ),
              RemoteTap(
                width: powerButtonSize,
                height: powerButtonSize,
                startColor: Colors.transparent,
                activeColor: Colors.transparent,
                onPressed: onTvListPressed,
                child: RemoteIcons.tv(),
              ),
            ],
          ),
        ),
        SizedBox(height: powerButtonSize / 2),
        RemoteMediaControls(
          allowSkip: allowSkip,
          buttonSize: buttonSize,
          spacing: powerButtonSize / 2,
          onPressed: onPressed,
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
            const keyCodeMap = {
              0: KeyCode.KEY_RIGHT,
              1: KeyCode.KEY_DOWN,
              2: KeyCode.KEY_LEFT,
              3: KeyCode.KEY_UP,
            };

            final keyCode = keyCodeMap[index];
            if (keyCode != null) {
              log('${keyCode.name} button pressed');
              onPressed(keyCode);
            }
          },
          onCenterClick: () {
            log('${KeyCode.KEY_ENTER.name} button pressed');
            onPressed(KeyCode.KEY_ENTER);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RemoteButton(
              size: buttonSize,
              onPressed: () {
                log('Back aka return button pressed');
                onPressed(KeyCode.KEY_RETURN);
              },
              child: RemoteIcons.back(iconColor),
            ),
            RemoteButton(
              size: buttonSize,
              onPressed: () {
                log('123 button pressed');
                onPressed(KeyCode.KEY_MORE);
              },
              child: RemoteIcons.num(iconColor),
            ),
          ],
        ),
        RemoteButton(
          size: buttonSize,
          onPressed: () {
            onPressed(KeyCode.KEY_HOME);
          },
          child: RemoteIcons.home(iconColor),
        ),
        SizedBox(height: buttonSize / 2),
        RemoteRocker(
          onPressedVolumeUp: () {
            log('Volume up button pressed');
            onPressed(KeyCode.KEY_VOLUP);
          },
          onPressedVolumeDown: () {
            log('Volume down button pressed');
            onPressed(KeyCode.KEY_VOLDOWN);
          },
          onPressedVolumeMute: () {
            log('Volume mute button pressed');
            onPressed(KeyCode.KEY_MUTE);
          },
          onPressedChannelUp: () {
            log('Next program button pressed');
            onPressed(KeyCode.KEY_CHUP);
          },
          onPressedChannelDown: () {
            log('Next program button pressed');
            onPressed(KeyCode.KEY_CHDOWN);
          },
        ),
      ],
    );
  }
}
