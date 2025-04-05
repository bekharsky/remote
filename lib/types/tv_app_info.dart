import 'dart:typed_data';

class AppInfo {
  final String appId;
  final String name;
  final String iconPath;
  final Uint8List? iconBytes;

  AppInfo({
    required this.appId,
    required this.name,
    required this.iconPath,
    this.iconBytes,
  });

  AppInfo copyWith({Uint8List? iconBytes}) {
    return AppInfo(
      appId: appId,
      name: name,
      iconPath: iconPath,
      iconBytes: iconBytes ?? this.iconBytes,
    );
  }
}
