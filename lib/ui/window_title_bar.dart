import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:remote/ui/window_buttons.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({
    super.key,
    required bool isMac,
  }) : _isMac = isMac;

  final bool _isMac;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
