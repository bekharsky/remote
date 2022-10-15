import 'package:flutter/material.dart';
import 'package:sheet/sheet.dart';

class RemoteSettings extends StatelessWidget {
  const RemoteSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SheetMediaQuery(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Samsung 5 Series'),
                leading: const Icon(Icons.tv),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text('Samsung 6 Series'),
                leading: const Icon(Icons.tv),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
