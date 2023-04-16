import 'dart:io';
import '../key_codes.dart';

main() async {
  var commander = Commander();
  print(await commander.sendKey(KeyCode.KEY_PAUSE));
}

class Commander {
  int token = 11735966;
  String ip = '192.168.3.6';

  Commander();

  sendKey(KeyCode key) async {
    final socket = await WebSocket.connect(
      "wss://$ip:8002/api/v2/channels/samsung.remote.control",
    );
    print('Connected to server!');

    return 'xxx';
  }
}
