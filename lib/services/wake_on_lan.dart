import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

class WakeOnLan {
  String mac = '';

  WakeOnLan(mac) {
    this.mac = mac.replaceAll(':', '');
  }

  /*
  Assembles the magic packet for wake-on-LAN functionality.
  Total size of the wake-on-LAN magic packet is 102 bytes, or 816 bits.
  First 6 bytes (48 bits) are 0xFF (255) with the remaining 96 bytes (768 bits) as the 6 byte (48 bit)
  MAC address repeated 16 times as specified by the wake-on-LAN specification.
  */
  Uint8List magicPacket() {
    final data = Uint8List(6 + 16 * 6);
    final addr = int.parse(mac, radix: 16);

    for (var i = 0; i < 6; i++) {
      data[i] = 0xff;
    }

    for (int i = 6; i < data.length; i += 6) {
      for (int j = 0; j < 6; j++) {
        data[i + j] = (addr >> (5 - j) * 8) & 0xff;
      }
    }

    return data;
  }

  void wake() async {
    // TODO: identify the actual gateway address
    var destAddr = InternetAddress('192.168.3.255');

    await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.broadcastEnabled = true;
      udpSocket.send(magicPacket(), destAddr, 9);
    }).catchError((err) {
      log('WOL ERROR');
      log(err.toString());
    });
  }
}
