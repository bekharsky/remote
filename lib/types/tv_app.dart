import 'dart:typed_data';

class TvApp {
  final String appId;
  final String name;
  final String iconPath;
  final Uint8List? iconBytes;
  // final List<String> ids;
  final bool visible;
  final int position;

  TvApp({
    required this.appId,
    required this.name,
    required this.iconPath,
    this.iconBytes,
    // required this.ids,
    required this.visible,
    required this.position,
  });

  factory TvApp.fromJson(Map<String, dynamic> json) {
    return TvApp(
      appId: json['orgs'][0], // или json['appId'], если будет явно
      name: json['name'],
      iconPath: json['icon'],
      iconBytes: null, // позже подгрузим отдельно
      // ids: List<String>.from(json['ids']),
      visible: json['visible'],
      position: json['position'],
    );
  }

  TvApp copyWith({Uint8List? iconBytes}) {
    return TvApp(
      appId: appId,
      name: name,
      iconPath: iconPath,
      iconBytes: iconBytes ?? this.iconBytes,
      // ids: ids,
      visible: visible,
      position: position,
    );
  }
}
