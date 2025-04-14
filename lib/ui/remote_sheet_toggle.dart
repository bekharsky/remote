import 'package:flutter/widgets.dart';

class RemoteSheetToggle extends StatelessWidget {
  final VoidCallback onTap;

  const RemoteSheetToggle({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 4,
          width: 56,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(73, 73, 73, 1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
