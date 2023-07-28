import 'package:flutter/material.dart';
import 'package:remote/device/collector.dart';
import 'package:remote/device/commander.dart';
import 'package:sheet/sheet.dart';
import '../types/tv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TvListView extends StatefulWidget {
  const TvListView({super.key});

  @override
  TvListViewState createState() => TvListViewState();
}

class TvListViewState extends State<TvListView> {
  SharedPreferences? prefs;
  final tvCollector = Collector();
  final dummyTv = Tv(
    name: 'Some Samsung TV',
    modelName: 'UW888',
    id: 'uuid',
    ip: '127.0.0.1',
    wifiMac: '00:00',
  );
  Future<List<Tv>> _tvsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    initPrefs();
    _tvsFuture = _loadItems();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<List<Tv>> _loadItems() async {
    List<Tv> tvs = await tvCollector.collect();
    return [
      ...tvs,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
      dummyTv,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tv>>(
      future: _tvsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                horizontalTitleGap: 6,
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                title: Text(
                  snapshot.data?[index].name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
                subtitle: Text(
                  snapshot.data?[index].modelName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 8),
                ),
                leading: Container(
                  alignment: Alignment.center,
                  width: 48,
                  child: const Icon(Icons.tv),
                ),
                // leading: const Icon(Icons.tv),
                onTap: () async {
                  Navigator.of(context).pop();
                  // TODO: all tv operations after click should happen inside main
                  final tv = snapshot.data?[index];

                  if (tv == null) {
                    return;
                  }

                  prefs?.setString('name', tv.name);
                  prefs?.setString('model', tv.modelName);

                  final commander = Commander(
                    name: 'Remote',
                    host: tv.ip,
                  );
                  final token = await commander.fetchToken();

                  if (token != null) {
                    prefs?.setString('token', token);
                  }
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Error loading items'),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }
}

class RemoteSettings extends StatelessWidget {
  const RemoteSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.transparent,
      child: SheetMediaQuery(
        child: TvListView(),
      ),
    );
  }
}
