import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_sheet.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteSkipRocker extends StatelessWidget {
  const RemoteSkipRocker({
    super.key,
    required this.widget,
  });

  final RemoteSheet widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // TODO: show those only on default player app
        // TODO: add separator on rockers
        children: [
          RemoteTap(
            onPressed: () {
              log('Rewind skip button pressed');
              widget.onPressedCallback(KeyCode.KEY_REWIND_);
            },
            width: 48,
            height: 40,
            child: RemoteIcons.prev(),
          ),
          RemoteTap(
            onPressed: () {
              log('Fast forward skip button pressed');
              widget.onPressedCallback(KeyCode.KEY_FF_);
            },
            width: 48,
            height: 40,
            child: RemoteIcons.next(),
          ),
        ],
      ),
    );
  }
}
