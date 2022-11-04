import 'dart:async';
import 'dart:io';
import 'dart:convert';

main() async {
  // String urn = 'urn:samsung.com:device:RemoteControlReceiver:1';
  String urn = 'ssdp:all';
  Discover discover = Discover(urn);
  List<String> result = await discover.search();
  print(result);
}

class Discover {
  String urn;
  String message = '';
  final int port = 1900;
  final String mcast = '239.255.255.250';

  Discover(this.urn) {
    message = ''
        'M-SEARCH * HTTP/1.1\r\n'
        'HOST: "$mcast:$port"\r\n'
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
    socket.send(message.codeUnits, InternetAddress(mcast), port);

    Timer(timeout, () {
      socket.close();
    });

    await socket.forEach((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = socket.receive();

        if (dg != null) {
          List<String> response = utf8.decode(dg.data).trim().split('\r\n');
          // String ip = '';

          for (var line in response) {
            int splitter = line.indexOf(':');

            if (splitter > -1) {
              String header = line.substring(0, splitter);
              String value = line.substring(splitter).replaceFirst(': ', '');

              if (header == 'ST') {
                buffer.add(value);
              }
            }
          }
        }
      }
    });

    return buffer;
  }
}
