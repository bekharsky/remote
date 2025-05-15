import 'package:flutter/cupertino.dart';

class RemoteAppsSkeleton extends StatefulWidget {
  const RemoteAppsSkeleton({
    super.key,
  });

  @override
  State<RemoteAppsSkeleton> createState() => _RemoteAppsSkeletonState();
}

class _RemoteAppsSkeletonState extends State<RemoteAppsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the blink animation
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Slow blinking
    )..repeat(reverse: true);

    _blinkAnimation = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _blinkController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of skeleton items
        itemBuilder: (context, index) {
          final itemMargin = EdgeInsets.only(
            left: index == 0 ? 12 : 0,
            right: 12,
          );

          return AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _blinkAnimation.value,
                child: Container(
                  margin: itemMargin,
                  width: 120, // Approximate width of an app icon
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(120, 120, 120, 1.0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
