import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:remote/types/key_codes.dart';

class SamsungHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Commander {
  Duration timeout = const Duration(milliseconds: 2000);

  Uri? wssUri;
  WebSocket? socket;
  String? token;
  String? host;

  Commander({name, this.host, this.token}) {
    HttpOverrides.global = SamsungHttpOverrides();
    final bytes = utf8.encode(name);
    final base64Name = base64.encode(bytes);

    wssUri = Uri(
      scheme: 'wss',
      port: 8002,
      host: host,
      path: 'api/v2/channels/samsung.remote.control',
      queryParameters: Map.from(
        {
          'name': base64Name,
          'token': token ?? '',
        },
      ),
    );
  }

  String? getToken() {
    return token;
  }

  setToken(token) {
    this.token = token;
  }

  Future<String?> fetchToken() async {
    final Completer<String> completer = Completer<String>();
    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        token = data['data']['token'];
        wssUri = wssUri?.replace(
          queryParameters: Map.from({
            ...wssUri!.queryParameters,
            'token': token,
          }),
        );
        socket?.close();
        completer.complete('$token');
      }
    });

    return completer.future;
  }

  Future<String?> sendKey(KeyCode keyCode) async {
    final Completer<String> completer = Completer<String>();
    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        token = data['data']['token'] ?? token;

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
        completer.complete('$token');
      }
    });

    return completer.future;
  }

  Future<String?> launchApp(String appId) async {
    final Completer<String> completer = Completer<String>();
    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      var data = jsonDecode(message);
      log(message);

      if (data['event'] == 'ms.channel.connect') {
        token = data['data']['token'] ?? token;

        String command = jsonEncode({
          "method": "ms.channel.emit",
          "params": {
            "event": "ed.apps.launch",
            "to": "host",
            "data": {
              "appId": appId,
              "action_type": "NATIVE_LAUNCH",
            }
          }
        });

        socket?.add(command);
        // socket?.close();
        completer.complete('$token');
      }
    });

    return completer.future;
  }
}
