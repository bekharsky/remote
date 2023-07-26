import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../key_codes.dart';

main() async {
  var sender = Sender(name: 'Remote', host: '192.168.3.6');
  await sender.fetchToken();
  await sender.sendKey(KeyCode.KEY_VOLDOWN);
}

class SamsungHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Sender {
  Duration timeout = const Duration(milliseconds: 2000);
  final _completer = Completer();

  Uri? wssUri;
  WebSocket? socket;
  String? token;
  String? host;
  String? name;

  Sender({name, this.host}) {
    HttpOverrides.global = SamsungHttpOverrides();
    final bytes = utf8.encode(name);
    final base64Name = base64.encode(bytes);

    this.name = base64Name;
  }

  getToken() {
    return token;
  }

  setToken(token) {
    this.token = token;
  }

  fetchToken() async {
    wssUri = Uri(
      scheme: 'wss',
      port: 8002,
      host: host,
      path: 'api/v2/channels/samsung.remote.control',
      queryParameters: Map.from(
        {
          'name': name,
          'token': token,
        },
      ),
    );

    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        token = data['data']['token'];
        socket?.close();
        _completer.complete();
      }
    });

    return _completer.future;
  }

  sendKey(KeyCode keyCode) async {
    wssUri = Uri(
      scheme: 'wss',
      port: 8002,
      host: host,
      path: 'api/v2/channels/samsung.remote.control',
      queryParameters: Map.from(
        {
          'name': name,
          'token': token,
        },
      ),
    );

    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        String command = jsonEncode({
          'method': 'ms.remote.control',
          'params': {
            'TypeOfRemote': 'SendRemoteKey',
            'Cmd': 'Click',
            'Option': 'false',
            'DataOfCmd': keyCode.name,
          }
        });

        socket?.add(command);
        socket?.close();
      }
    });
  }
}
