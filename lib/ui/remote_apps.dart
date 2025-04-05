import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remote/ui/app_drag_handle.dart';
import 'package:remote/ui/app_remove_icon.dart';
import 'package:remote/ui/app_icon.dart';
import '../types/tv_app.dart';

class RemoteApps extends StatefulWidget {
  final Future<List<TvApp>> Function() loadApps;
  final void Function(String) onAppCallback;

  const RemoteApps({
    Key? key,
    required this.loadApps,
    required this.onAppCallback,
  }) : super(key: key);

  @override
  State<RemoteApps> createState() => _RemoteAppsState();
}

class _RemoteAppsState extends State<RemoteApps>
    with SingleTickerProviderStateMixin {
  late final Function(String) onAppCallback = widget.onAppCallback;
  bool showControls = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  List<TvApp> apps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _shakeAnimation = Tween(begin: -0.02, end: 0.02).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _loadApps();
  }

  Future<void> _loadApps() async {
    final loadedApps = await widget.loadApps();

    setState(() {
      apps = loadedApps;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void onRemoveHandler(int index) {
    setState(() {
      apps.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 120,
      child: ReorderableList(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          final id = app.appId;
          final isEven = index % 2 == 0;
          final itemMargin = EdgeInsets.only(
            left: index == 0 ? 12 : 0,
            right: 12,
          );

          return GestureDetector(
            key: ValueKey(app),
            onLongPress: () {
              setState(() {
                showControls = !showControls;
                if (showControls) {
                  _shakeController.repeat(reverse: true);
                } else {
                  _shakeController.stop();
                }
              });
            },
            onTap: () {
              if (!showControls) {
                onAppCallback(id);
              }
            },
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: showControls
                      ? isEven
                          ? -_shakeAnimation.value
                          : _shakeAnimation.value
                      : 0,
                  child: Container(
                    margin: itemMargin,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        AppIcon(app: app),
                        if (showControls) ...[
                          AppDragHandle(index: index),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap: () {
                                onRemoveHandler(index);
                              },
                              child: const AppRemoveIcon(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) newIndex -= 1;
          setState(() {
            final app = apps.removeAt(oldIndex);
            apps.insert(newIndex, app);
          });
        },
      ),
    );
  }
}
