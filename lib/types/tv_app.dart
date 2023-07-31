class TvApp {
  String name;
  String icon;
  List<String> ids;

  TvApp({
    required this.name,
    required this.icon,
    required this.ids,
  });

  factory TvApp.fromJson(Map<String, dynamic> json) {
    return TvApp(
      name: json['name'],
      icon: json['icon'],
      ids: List<String>.from(json['ids']),
    );
  }
}
