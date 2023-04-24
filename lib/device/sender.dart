import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../key_codes.dart';

main() async {
  var sender = Sender('Remote', '192.168.3.6');
  await sender.getToken();
  await sender.sendKey(KeyCode.KEY_HOME);
  print(sender.wssUri);
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
  final wssUriTemplate = Uri(
    scheme: 'wss',
    port: 8002,
    path: 'api/v2/channels/samsung.remote.control',
  );
  String? token;
  String? name;
  Uri? wssUri;
  WebSocket? socket;

  Sender(name, host) {
    HttpOverrides.global = SamsungHttpOverrides();

    final bytes = utf8.encode(name);
    final base64Name = base64.encode(bytes);

    wssUri = wssUriTemplate.replace(
      host: host,
      queryParameters: Map.from({
        'name': base64Name,
      }),
    );
  }

  getToken() async {
    print("getToken $wssUri");
    socket = await WebSocket.connect(wssUri.toString());

    socket?.listen((message) {
      var data = jsonDecode(message);

      if (data['event'] == 'ms.channel.connect') {
        token = data['data']['token'];
        final bytes = utf8.encode(token!);
        final base64Token = base64Encode(bytes);

        wssUri = wssUriTemplate.replace(
          queryParameters: Map.from({
            'token': base64Token,
            ...wssUri!.queryParameters,
          }),
        );

        print("getToken token $wssUri");

        socket?.close();
        _completer.complete();
      }
    });

    return _completer.future;
  }

  sendKey(KeyCode keyCode) async {
    print("sendKey $wssUri");
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
