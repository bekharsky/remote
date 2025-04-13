import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_tap.dart';

class RemoteSheetSkipRocker extends StatelessWidget {
  const RemoteSheetSkipRocker({
    super.key,
    required this.onPressed,
  });

  final void Function(KeyCode) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RemoteTap(
            onPressed: () {
              log('Rewind skip button pressed');
              onPressed(KeyCode.KEY_REWIND_);
            },
            width: 48,
            height: 40,
            child: RemoteIcons.prev(),
          ),
          RemoteTap(
            onPressed: () {
              log('Fast forward skip button pressed');
              onPressed(KeyCode.KEY_FF_);
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
