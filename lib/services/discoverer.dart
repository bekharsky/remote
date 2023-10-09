import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

class Discoverer {
  String message = '';
  final int port = 0;
  final int ssdpPort = 1900;
  final String ssdpHost = '239.255.255.250';
  late InternetAddress multicastIPv4;
  late List<NetworkInterface> interfaces;

  Discoverer(String usn) {
    multicastIPv4 = InternetAddress(ssdpHost);
    message = ''
        'M-SEARCH * HTTP/1.1\r\n'
        'HOST: "$ssdpHost:$ssdpPort"\r\n'
        'ST: $usn\r\n'
        'MAN: "ssdp:discover"\r\n'
        'MX: 5\r\n'
        'USER-AGENT: unix/5.1 UPnP/1.1 crash/1.0\r\n\r\n';
  }

  Future<List<String>> search() async {
    interfaces = await NetworkInterface.list();
    List<String> buffer = [];
    Duration timeout = const Duration(seconds: 5);
    InternetAddress anyIPv4 = InternetAddress.anyIPv4;
    RawDatagramSocket socket = await RawDatagramSocket.bind(anyIPv4, port);

    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;
    socket.multicastHops = 50;

    try {
      socket.joinMulticast(multicastIPv4);
    } on OSError {}

    for (var interface in interfaces) {
      try {
        socket.joinMulticast(multicastIPv4, interface);
      } on OSError {}
    }

    socket.send(message.codeUnits, multicastIPv4, ssdpPort);

    Timer(timeout, () {
      socket.close();
    });

    await socket.forEach((RawSocketEvent event) {
      log(event.toString());
      if (event == RawSocketEvent.read) {
        Datagram? dg = socket.receive();

        if (dg != null) {
          var response = utf8.decode(dg.data).trim().split('\r\n');
          String location = '';

          for (var line in response) {
            log(line);
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
