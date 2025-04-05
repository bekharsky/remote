import 'package:flutter/material.dart';
import 'package:remote/ui/app_drag_icon.dart';

class AppDragHandle extends StatelessWidget {
  const AppDragHandle({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: ReorderableDragStartListener(
        index: index,
        child: const AppDragIcon(),
      ),
    );
  }
}
