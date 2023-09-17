import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

/*
Example request:
POST 'http://192.168.3.6:9197/upnp/control/RenderingControl1'
Content-Type text/xml
SOAPAction "urn:schemas-upnp-org:service:RenderingControl:1#GetVolume"
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body>
    <ns0:GetVolume xmlns:ns0="urn:schemas-upnp-org:service:RenderingControl:1">
      <InstanceID>0</InstanceID>
      <Channel>Master</Channel>
    </ns0:GetVolume>
  </s:Body>
</s:Envelope>

Example response:
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <u:GetVolumeResponse xmlns:u="urn:schemas-upnp-org:service:RenderingControl:1">
            <CurrentVolume>0</CurrentVolume>
        </u:GetVolumeResponse>
    </s:Body>
</s:Envelope>
*/

class SoapUpnp {
  String schema = 'urn:schemas-upnp-org:service:RenderingControl:1';
  int port = 9197;
  late Uri uri;

  SoapUpnp(host) {
    uri = Uri.parse("http://$host:$port/upnp/control/RenderingControl1");
  }

  Future<int> getVolume() async {
    final document = await sendSoapRequest_('GetVolume');
    final el = document.findAllElements('CurrentVolume').first.firstChild;
    final value = el?.value ?? '0';
    return int.parse(value);
  }

  Future<bool> getMute() async {
    final document = await sendSoapRequest_('GetMute');
    final el = document.findAllElements('CurrentMute').first.firstChild;
    final value = el?.value ?? '0';
    return int.parse(value) != 0;
  }

  Future<XmlDocument> sendSoapRequest_(String type) async {
    final body = buildSoapEnvelope_(type);
    final action = buildSoapActionHeader_(type);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'text/xml',
        'SOAPAction': action,
      },
      body: utf8.encode(body),
    );

    return XmlDocument.parse(response.body);
  }

  String buildSoapEnvelope_(String type) {
    return '''
      <?xml version="1.0" encoding="utf-8"?>
      <s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
        <s:Body>
          <ns0:$type xmlns:ns0="$schema">
            <InstanceID>0</InstanceID>
            <Channel>Master</Channel>
          </ns0:$type>
        </s:Body>
      </s:Envelope>
    ''';
  }

  String buildSoapActionHeader_(String type) {
    return "\"urn:schemas-upnp-org:service:RenderingControl:1#$type\"";
  }
}
