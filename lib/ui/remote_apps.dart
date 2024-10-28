import 'package:flutter/material.dart';
import '../types/tv_app.dart';

class RemoteApps extends StatefulWidget {
  final List<TvApp> apps;
  final void Function(String) onAppCallback;

  const RemoteApps({
    Key? key,
    required this.apps,
    required this.onAppCallback,
  }) : super(key: key);

  @override
  State<RemoteApps> createState() => _RemoteAppsState();
}

class _RemoteAppsState extends State<RemoteApps> {
  late final List<TvApp> apps = widget.apps;
  late final Function(String) onAppCallback = widget.onAppCallback;
  bool showRemoveButton = false;

  @override
  void initState() {
    super.initState();
  }

  void onRemoveHandler(int index) {
    return setState(() {
      apps.removeAt(index); // Remove the app from the list
      showRemoveButton = false; // Exit remove mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ReorderableList(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        itemBuilder: (BuildContext context, int index) {
          final app = apps[index];
          final id = app.orgs[0];
          final itemMargin = EdgeInsets.only(
            left: index == 0 ? 12 : 0,
            right: 12,
          );

          return Container(
            key: ValueKey(app),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            margin: itemMargin,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (showRemoveButton) {
                      setState(() {
                        showRemoveButton = false;
                      });
                    } else {
                      onAppCallback(id);
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      showRemoveButton = true;
                    });
                  },
                  child: Thumb(app: app),
                ),
                DragHandle(index: index),
                if (showRemoveButton) ...[
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () {
                        onRemoveHandler(index);
                      },
                      child: const RemoveIcon(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          setState(() {
            // TODO: store positions in settings
            final app = apps.removeAt(oldIndex);
            apps.insert(newIndex, app);
          });
        },
      ),
    );
  }
}

class RemoveIcon extends StatelessWidget {
  const RemoveIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.white38,
        BlendMode.srcATop,
      ),
      child: Icon(
        Icons.close,
        size: 16,
        color: Colors.black,
      ),
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: ReorderableDragStartListener(
        index: index,
        child: const DragIcon(),
      ),
    );
  }
}

class Thumb extends StatelessWidget {
  const Thumb({
    super.key,
    required this.app,
  });

  final TvApp app;
  final appIconsPath = 'assets/icons';

  @override
  Widget build(BuildContext context) {
    final icon = app.icon;
    final path = '$appIconsPath/$icon';

    return Image.asset(
      width: 120,
      height: 120,
      path,
      fit: BoxFit.cover,
    );
  }
}

class DragIcon extends StatelessWidget {
  const DragIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.white38,
        BlendMode.srcATop,
      ),
      child: Icon(
        Icons.drag_indicator,
        size: 16,
        color: Colors.black,
      ),
    );
  }
}
