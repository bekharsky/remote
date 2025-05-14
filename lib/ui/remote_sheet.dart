import 'package:flutter/material.dart';
import 'package:remote/theme/app_theme.dart';
// import 'package:flutter/widgets.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_controls.dart';
import 'package:remote/ui/remote_sheet_toggle.dart';
import 'dart:io';
import 'dart:developer';
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
            RemoteControls(
              onPressed: widget.onPressed,
              onPowerPressed: widget.onPowerPressed,
              onTvListPressed: widget.onTvListPressed,
              allowSkip: widget.allowSkip,
            ),
          ],
        ),
      ),
    );
  }
}
