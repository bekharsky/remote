import 'package:flutter/material.dart';
import 'package:remote/device/collector.dart';
import 'package:sheet/sheet.dart';
import '../types/tv.dart';

class TvListView extends StatefulWidget {
  final void Function(Tv) onTapCallback;
  const TvListView({super.key, required this.onTapCallback});

  @override
  TvListViewState createState() => TvListViewState();
}

class TvListViewState extends State<TvListView> {
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
    _tvsFuture = _loadItems();
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
                  final tv = snapshot.data?[index];

                  if (tv == null) {
                    return;
                  }

                  widget.onTapCallback(tv);
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
  final void Function(Tv) onTapCallback;
  const RemoteSettings({super.key, required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SheetMediaQuery(
        child: TvListView(onTapCallback: onTapCallback),
      ),
    );
  }
}
