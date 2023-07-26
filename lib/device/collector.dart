import 'dart:convert';
import 'package:http/http.dart' as http;
import '../types/device_info.dart';
import 'discoverer.dart';
import '../types/tv.dart';

main() async {
  var collector = Collector();
  print(await collector.collect());
}

class Collector {
  final urn = 'urn:samsung.com:device:RemoteControlReceiver:1';
  final headers = {'Accept': 'application/json'};

  Collector();

  collect() async {
    List<Tv> tvs = [];
    final rcrList = await Discoverer(urn).search();

    for (var location in rcrList) {
      if (location == '') {
        continue;
      }

      final uri = Uri.parse(location).replace(port: 8001, path: '/api/v2/');
      final response = await http.get(uri, headers: headers);
      final deviceInfo = DeviceInfo.fromJson(json.decode(response.body));
      final device = deviceInfo.device;
      final tv = Tv(
        name: device.name,
        modelName: device.modelName,
        id: device.id,
        ip: device.ip,
        wifiMac: device.wifiMac,
      );

      tvs.add(tv);
    }

    return tvs;
  }
}
