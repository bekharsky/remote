import 'dart:async';
import 'dart:io';
import 'dart:convert';

class Discoverer {
  String urn;
  String message = '';
  final int port = 0;
  final int ssdpPort = 1900;
  final String ssdpHost = '239.255.255.250';

  Discoverer(this.urn) {
    message = ''
        'M-SEARCH * HTTP/1.1\r\n'
        'HOST: "$ssdpHost:$ssdpPort"\r\n'
        'MAN: "ssdp:discover"\r\n'
        'MX: 3\r\n'
        'ST: $urn\r\n\r\n';
  }

  Future<List<String>> search() async {
    List<String> buffer = [];
    Duration timeout = const Duration(milliseconds: 2000);
    InternetAddress anyIPv4 = InternetAddress.anyIPv4;
    RawDatagramSocket socket = await RawDatagramSocket.bind(anyIPv4, port);

    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;
    socket.joinMulticast(InternetAddress(ssdpHost));
    socket.send(message.codeUnits, InternetAddress(ssdpHost), ssdpPort);

    Timer(timeout, () {
      socket.close();
    });

    await socket.forEach((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = socket.receive();

        if (dg != null) {
          var response = utf8.decode(dg.data).trim().split('\r\n');
          String location = '';

          for (var line in response) {
            int splitter = line.indexOf(':');

            if (splitter > -1) {
              var header = line.substring(0, splitter);
              var value = line.substring(splitter).replaceFirst(': ', '');

              if (header == 'LOCATION') {
                location = value;
              }
            }
          }

          buffer.add(location);
        }
      }
    });

    return buffer;
  }
}
