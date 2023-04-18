import 'dart:convert';
import 'dart:io';
import '../key_codes.dart';

main() async {
  var commander = Commander();
  await commander.sendKey(KeyCode.KEY_PAUSE);
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

  sendKey(KeyCode keyCode) async {
    final bytes = utf8.encode(name);
    final base64Name = base64.encode(bytes);
    final wssUri = wssUriTemplate.replace(
      queryParameters: Map.from({
        'token': "$token",
        'name': base64Name,
      }),
    );

    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      // print(message);
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        token = int.parse(data['data']['clients'][0]['attributes']['token']);
        // print(token);
        String command = jsonEncode({
          'method': 'ms.remote.control',
          'params': {
            'TypeOfRemote': 'SendRemoteKey',
            'Cmd': 'Click',
            'Option': 'false',
            'DataOfCmd': keyCode.name,
          }
        });
        // print(command);
        socket?.add(command);
        socket?.close();
      }
    });
  }
}
