import 'package:flutter/material.dart';
import 'package:remote/ui/remote_button.dart';
import 'package:remote/ui/remote_skip_rocker.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/theme/app_theme.dart';

class RemoteMediaControls extends StatelessWidget {
  final bool allowSkip;
  final double buttonSize;
  final double spacing;
  final void Function(KeyCode) onPressed;
  final Widget? skipWidget;

  const RemoteMediaControls({
    super.key,
    required this.allowSkip,
    required this.buttonSize,
    required this.spacing,
    required this.onPressed,
    this.skipWidget,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = AppTheme.of(context).colors.onPrimary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RemoteButton(
              size: buttonSize,
              onPressed: () => onPressed(KeyCode.KEY_PLAY),
              child: RemoteIcons.play(iconColor),
            ),
            if (allowSkip) RemoteSkipRocker(onPressed: onPressed),
            RemoteButton(
              size: buttonSize,
              onPressed: () => onPressed(KeyCode.KEY_PAUSE),
              child: RemoteIcons.pause(iconColor),
            ),
          ],
        ),
        if (allowSkip) SizedBox(height: spacing),
      ],
    );
  }
}
