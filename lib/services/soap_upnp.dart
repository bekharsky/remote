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
  // TODO: constructor
  static const endpoint =
      'http://192.168.3.6:9197/upnp/control/RenderingControl1';
  static const action =
      '"urn:schemas-upnp-org:service:RenderingControl:1#GetVolume"';

  // TODO: create from XML?
  static const body = '''
    <?xml version="1.0" encoding="utf-8"?>
    <s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      <s:Body>
        <ns0:GetVolume xmlns:ns0="urn:schemas-upnp-org:service:RenderingControl:1">
          <InstanceID>0</InstanceID>
          <Channel>Master</Channel>
        </ns0:GetVolume>
      </s:Body>
    </s:Envelope>
  ''';

  final uri = Uri.parse(endpoint);

  // Future<XmlDocument> post() async {
  getVolume() async {
    // TODO: timeout for checking availability

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'text/xml',
        'SOAPAction': action,
      },
      body: utf8.encode(body),
    );

    // TODO: success check

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    final document = XmlDocument.parse(response.body);

    return response.body;
  }
}
