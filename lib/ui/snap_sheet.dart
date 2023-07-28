import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:remote/key_codes.dart';
import 'package:remote/ui/remote.dart';
import 'package:sheet/sheet.dart';
import '../types/tv.dart';

class SnapSheet extends StatefulWidget {
  final void Function(Tv) onTvSelectCallback;
  final void Function(KeyCode) onButtonPressCallback;
  const SnapSheet({
    super.key,
    required this.onTvSelectCallback,
    required this.onButtonPressCallback,
  });

  @override
  SnapSheetState createState() => SnapSheetState();
}

class SnapSheetState extends State<SnapSheet> {
  final SheetController controller = SheetController();

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
      child: Remote(
        onTvSelectCallback: widget.onTvSelectCallback,
        onButtonPressCallback: widget.onButtonPressCallback,
      ),
    );
  }
}
