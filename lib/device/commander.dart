import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../key_codes.dart';

main() async {
  var commander = Commander();
  print(await commander.sendKey(KeyCode.KEY_PAUSE));
}

class SamsungHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Commander {
  final timeout = const Duration(milliseconds: 500);
  int? token = 19197254;
  String name = 'Remote';
  Uri wssUriTemplate = Uri(
    scheme: 'wss',
    host: '192.168.3.6',
    port: 8002,
    path: 'api/v2/channels/samsung.remote.control',
  );
  WebSocket? socket;

  Commander() {
    HttpOverrides.global = SamsungHttpOverrides();
  }

  sendKey(KeyCode key) async {
    final bytes = utf8.encode(name);
    final base64Name = base64.encode(bytes);

    final wssUri = wssUriTemplate.replace(
      queryParameters: Map.from({
        'token': "$token",
        'name': base64Name,
      }),
    );

    print(wssUri.toString());

    socket = await WebSocket.connect(wssUri.toString());
    print('Connected to server!');

    socket?.listen((message) {
      print(message);
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        token = int.parse(data['data']['clients'][0]['attributes']['token']);
        print(token);

        // send key
        // close socket
      }

      Timer(timeout, () {
        socket?.close();
      });
    });

    return 'xxx';
  }
}
