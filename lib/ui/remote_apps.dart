import 'package:flutter/widgets.dart';
import 'dart:developer';
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
  final appIconsPath = 'assets/icons';
  late final List<TvApp> apps = widget.apps;
  late final Function(String) onAppCallback = widget.onAppCallback;
  List<bool> _enabledList = [];

  @override
  void initState() {
    super.initState();
    _enabledList = List<bool>.filled(apps.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ReorderableList(
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
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        itemBuilder: (BuildContext context, int index) {
          final app = apps[index];
          final id = app.orgs[0];
          final icon = app.icon;
          final path = '$appIconsPath/$icon';
          final isLastItem = index == apps.length - 1;

          EdgeInsets itemMargin = EdgeInsets.fromLTRB(
            16,
            0,
            isLastItem ? 16 : 0,
            0,
          );

          return GestureDetector(
            key: ValueKey(app),
            onLongPress: () {
              setState(() {
                _enabledList[index] = true;
              });
            },
            onLongPressUp: () {
              setState(() {
                _enabledList[index] = false;
              });
            },
            child: ReorderableDragStartListener(
              index: index,
              enabled: false,
              child: GestureDetector(
                onTap: () {
                  log('App launch: $id');
                  onAppCallback(id);
                },
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: itemMargin,
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
