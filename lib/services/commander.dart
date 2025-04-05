import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:remote/types/key_codes.dart';
import 'package:remote/types/tv_app.dart';

class SamsungHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Commander {
  Uri? wssUri;
  WebSocket? socket;
  String? token;
  String? host;

  final _messageController = StreamController<String>.broadcast();
  bool _reconnectLock = false;

  Commander({required String name, this.host, this.token}) {
    HttpOverrides.global = SamsungHttpOverrides();
    final base64Name = base64.encode(utf8.encode(name));
    wssUri = Uri(
      scheme: 'wss',
      host: host,
      port: 8002,
      path: 'api/v2/channels/samsung.remote.control',
      queryParameters: {
        'name': base64Name,
        'token': token ?? '',
      },
    );
  }

  Future<void> _ensureConnected() async {
    if (socket != null && socket!.readyState == WebSocket.open) return;

    if (_reconnectLock) {
      // Ждём, пока другое подключение завершится
      while (_reconnectLock) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    _reconnectLock = true;
    try {
      socket = await WebSocket.connect(wssUri.toString());

      socket!.listen(
        (message) {
          _messageController.add(message);
          final data = jsonDecode(message);
          if (data['event'] == 'ms.channel.connect') {
            token = data['data']['token'] ?? token;
            wssUri = wssUri?.replace(queryParameters: {
              ...wssUri!.queryParameters,
              'token': token!,
            });
          }
        },
        onDone: () {
          log('WebSocket closed. Trying to reconnect...');
          socket = null;
        },
        onError: (e) {
          log('WebSocket error: $e');
          socket = null;
        },
        cancelOnError: true,
      );
    } catch (e) {
      log('Failed to connect to WebSocket: $e');
      socket = null;
    } finally {
      _reconnectLock = false;
    }
  }

  Future<String?> fetchToken() async {
    await _ensureConnected();
    return token;
  }

  Future<String?> sendKey(KeyCode keyCode) async {
    await _ensureConnected();

    final command = jsonEncode({
      'method': 'ms.remote.control',
      'params': {
        'Cmd': 'Click',
        'DataOfCmd': keyCode.name,
        'Option': 'false',
        'TypeOfRemote': 'SendRemoteKey',
      },
    });

    socket?.add(command);
    return 'OK';
  }

  Future<String?> getInstalledApps() async {
    await _ensureConnected();
    final completer = Completer<String>();

    final command = jsonEncode({
      'method': 'ms.channel.emit',
      'params': {
        'event': 'ed.installedApp.get',
        'to': 'host',
        'data': '',
      }
    });

    socket?.add(command);

    late StreamSubscription sub;
    sub = _messageController.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['event'] == 'ed.installedApp.get') {
        log('Installed apps: $message');
        sub.cancel();
        completer.complete(message);
      }
    });

    return completer.future;
  }

  Future<List<TvApp>> getAppsWithIcons() async {
    await _ensureConnected();
    final completer = Completer<List<TvApp>>();

    final command = jsonEncode({
      'method': 'ms.channel.emit',
      'params': {
        'event': 'ed.installedApp.get',
        'to': 'host',
        'data': '',
      }
    });

    final List<TvApp> apps = [];

    late StreamSubscription sub;
    sub = _messageController.stream.listen((message) async {
      final data = jsonDecode(message);

      if (data['event'] == 'ed.installedApp.get') {
        sub.cancel();
        final rawApps = data['data']['data'] as List;

        // Асинхронно обрабатываем каждое приложение
        for (int i = 0; i < rawApps.length; i++) {
          final app = rawApps[i];
          final appInfo = TvApp(
            appId: app['appId'],
            name: app['name'],
            iconPath: app['icon'],
            visible: true,
            position: i,
          );

          // Получаем иконку для текущего приложения
          final appWithIcon = await _fetchIconForApp(appInfo);
          apps.add(appWithIcon);
        }

        completer.complete(apps);
      }
    });

    socket?.add(command);
    return completer.future;
  }

  Future<TvApp> _fetchIconForApp(TvApp app) async {
    final completer = Completer<TvApp>();

    final command = jsonEncode({
      'method': 'ms.channel.emit',
      'params': {
        'event': 'ed.apps.icon',
        'to': 'host',
        'data': {'iconPath': app.iconPath},
      },
    });

    late StreamSubscription sub;
    sub = _messageController.stream.listen((message) {
      final data = jsonDecode(message);

      if (data['event'] == 'ed.apps.icon') {
        sub.cancel();

        final base64Data = data['data']['imageBase64'];
        final iconBytes = base64.decode(base64Data);
        completer.complete(app.copyWith(iconBytes: iconBytes));
      }
    });

    socket?.add(command);

    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        sub.cancel();
        return app; // возвращаем без иконки, если не успели загрузить
      },
    );
  }

//   Future<String?> launchApp(String appId) async {
//     await _ensureConnected();
//     final complete  late StreamSubscription sub;
// r = Completer<String>();

//     final command = jsonEncode({
//       'method': 'ms.channel.emit',
//       'params': {
//         'event': 'ed.apps.launch',
//         'to': 'host',
//         'data': {
//           'appId': appId,
//           'action_type': 'NATIVE_LAUNCH',
//         },
//       }
//     });

//     socket?.add(command);
//     completer.complete('App launch command sent');
//     return completer.future;
//   }

  Future<void> disconnect() async {
    await socket?.close();
    socket = null;
  }
}
