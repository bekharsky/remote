class TvApp {
  String name;
  String icon;
  List<String> ids;
  List<String> orgs;
  bool visible;
  int position;

  TvApp({
    required this.name,
    required this.icon,
    required this.ids,
    required this.orgs,
    required this.visible,
    required this.position,
  });

  factory TvApp.fromJson(Map<String, dynamic> json) {
    return TvApp(
      name: json['name'],
      icon: json['icon'],
      ids: List<String>.from(json['ids']),
      orgs: List<String>.from(json['orgs']),
      visible: json['visible'],
      position: json['position'],
    );
  }
}
