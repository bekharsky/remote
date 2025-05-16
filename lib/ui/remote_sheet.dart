import 'package:flutter/widgets.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/types/key_codes.dart';
import 'package:remote/ui/remote_controls.dart';
import 'package:remote/ui/remote_sheet_toggle.dart';
import 'dart:io';
import 'dart:developer';

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

class RemoteSheetState extends State<RemoteSheet>
    with SingleTickerProviderStateMixin {
  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final double _hPad = _isMobile ? 48 : 24;
  static final double _vPad = _isMobile ? 24 : 16;
  static const double minExtent = 430;
  static const double maxExtent = 570;

  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentOffset = maxExtent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _animateTo(double target, {bool spring = false}) {
    final animation = Tween<double>(begin: _currentOffset, end: target).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: spring ? Curves.elasticOut : Curves.easeOut,
      ),
    );
    _animation = animation;

    _animationController
      ..duration = spring
          ? const Duration(milliseconds: 600)
          : const Duration(milliseconds: 300)
      ..reset();

    _animation.addListener(() {
      setState(() {
        _currentOffset = _animation.value;
      });
      widget.onSheetShift(_currentOffset);
    });

    _animationController.forward();
  }

  void toggleSheet([bool force = false]) {
    log('Offset: $_currentOffset');
    final isOpen = _currentOffset >= maxExtent - 10;
    _animateTo((isOpen && !force) ? minExtent : maxExtent, spring: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: screenHeight,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: screenHeight - _currentOffset,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _currentOffset -= details.delta.dy;
                      _currentOffset =
                          _currentOffset.clamp(minExtent, maxExtent);
                      widget.onSheetShift(_currentOffset);
                    });
                  },
                  onVerticalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;

                    if (velocity > 700) {
                      _animateTo(minExtent, spring: true);
                    } else if (velocity < -700) {
                      _animateTo(maxExtent, spring: true);
                    } else {
                      final midpoint = (maxExtent + minExtent) / 2;
                      if (_currentOffset > midpoint) {
                        _animateTo(maxExtent, spring: true);
                      } else {
                        _animateTo(minExtent, spring: true);
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colors.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(_hPad, 0, _hPad, _vPad),
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      minHeight: 0,
                      maxHeight: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
