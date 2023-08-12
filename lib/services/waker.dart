import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

class Waker {
  String mac;

  Waker(this.mac);

  void wake() async {
    var destAddr = InternetAddress("255.255.255.255");

    await RawDatagramSocket.bind(InternetAddress.anyIPv4, 9)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.broadcastEnabled = true;
      Uint8List data = Uint8List(6 + 16 * 6);

      var addr = 0x4cedfb3f0b45;
      addr = int.parse(mac, radix: 16);

      for (var i = 0; i < 6; i++) {
        data[i] = 0xff;
      }

      for (int i = 6; i < data.length; i += 6) {
        for (int j = 0; j < 6; j++) {
          data[i + j] = (addr >> (5 - j) * 8) & 0xff;
        }
      }

      udpSocket.send(data, destAddr, 9);
    }).catchError((err) {
      log('help');
    });
  }
}
