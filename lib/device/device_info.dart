class DeviceInfo {
  Device device;
  String id;
  String isSupport;
  String name;
  String remote;
  String type;
  String uri;
  String version;

  DeviceInfo({
    required this.device,
    required this.id,
    required this.isSupport,
    required this.name,
    required this.remote,
    required this.type,
    required this.uri,
    required this.version,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      device: Device.fromJson(json['device']),
      id: json['id'],
      isSupport: json['isSupport'],
      name: json['name'],
      remote: json['remote'],
      type: json['type'],
      uri: json['uri'],
      version: json['version'],
    );
  }
}

class Device {
  bool frameTVSupport;
  bool gamePadSupport;
  bool imeSyncedSupport;
  String os;
  bool tokenAuthSupport;
  bool voiceSupport;
  String countryCode;
  String description;
  String developerIP;
  String developerMode;
  String duid;
  String firmwareVersion;
  String id;
  String ip;
  String model;
  String modelName;
  String name;
  String networkType;
  String resolution;
  bool smartHubAgreement;
  String ssid;
  String type;
  String udn;
  String wifiMac;

  Device({
    required this.frameTVSupport,
    required this.gamePadSupport,
    required this.imeSyncedSupport,
    required this.os,
    required this.tokenAuthSupport,
    required this.voiceSupport,
    required this.countryCode,
    required this.description,
    required this.developerIP,
    required this.developerMode,
    required this.duid,
    required this.firmwareVersion,
    required this.id,
    required this.ip,
    required this.model,
    required this.modelName,
    required this.name,
    required this.networkType,
    required this.resolution,
    required this.smartHubAgreement,
    required this.ssid,
    required this.type,
    required this.udn,
    required this.wifiMac,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      frameTVSupport: json['FrameTVSupport'] == 'true',
      gamePadSupport: json['GamePadSupport'] == 'true',
      imeSyncedSupport: json['ImeSyncedSupport'] == 'true',
      os: json['OS'],
      tokenAuthSupport: json['TokenAuthSupport'] == 'true',
      voiceSupport: json['VoiceSupport'] == 'true',
      countryCode: json['countryCode'],
      description: json['description'],
      developerIP: json['developerIP'],
      developerMode: json['developerMode'],
      duid: json['duid'],
      firmwareVersion: json['firmwareVersion'],
      id: json['id'],
      ip: json['ip'],
      model: json['model'],
      modelName: json['modelName'],
      name: json['name'],
      networkType: json['networkType'],
      resolution: json['resolution'],
      smartHubAgreement: json['smartHubAgreement'] == 'true',
      ssid: json['ssid'],
      type: json['type'],
      udn: json['udn'],
      wifiMac: json['wifiMac'],
    );
  }
}
