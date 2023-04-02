import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'discover.dart';

main() async {
  var urn = 'urn:samsung.com:device:RemoteControlReceiver:1';
  var tvCollector = TvCollector(urn);
  print(await tvCollector.collect());
}

class TvCollector {
  final String urn;
  final Map<String, String> headers = {'Accept': 'application/xml'};

  TvCollector(this.urn);

  collect() async {
    List<Map<String, Object>> tvs = [];
    var list = await Discover(urn).search();

    for (var location in list) {
      if (location == '') {
        continue;
      }

      final uri = Uri.parse(location);
      final response = await http.get(uri, headers: headers);
      final rcrDoc = XmlDocument.parse(response.body);
      final name =
          rcrDoc.findAllElements('friendlyName').map((node) => node.text).first;
      final model =
          rcrDoc.findAllElements('modelName').map((node) => node.text).first;
      final uuid = rcrDoc.findAllElements('UDN').map((node) => node.text).first;

      tvs.add({
        'name': name,
        'model': model,
        'uuid': uuid,
        'host': uri.host,
        'port': uri.port
      });
    }

    return tvs;
  }
}
