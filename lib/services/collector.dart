import 'dart:convert';
import 'package:http/http.dart' as http;
import 'discoverer.dart';
import 'package:remote/types/tv_info.dart';
import 'package:remote/types/tv.dart';

class Collector {
  final urn = 'urn:samsung.com:device:RemoteControlReceiver:1';
  final headers = {'Accept': 'application/json'};

  collect() async {
    List<ConnectedTv> tvs = [];
    final rcrList = await Discoverer(urn).search();

    for (var location in rcrList) {
      if (location == '') {
        continue;
      }

      final uri = Uri.parse(location).replace(port: 8001, path: '/api/v2/');
      final response = await http.get(uri, headers: headers);
      final deviceInfo = TvInfo.fromJson(json.decode(response.body));
      final device = deviceInfo.device;
      final tv = ConnectedTv(
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
