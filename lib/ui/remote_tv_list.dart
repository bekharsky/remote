import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Только для иконки
import 'package:remote/services/collector.dart';
import '../types/tv.dart';

class TvList extends StatefulWidget {
  final void Function(ConnectedTv) onTapCallback;
  const TvList({super.key, required this.onTapCallback});

  @override
  TvListState createState() => TvListState();
}

class TvListState extends State<TvList> {
  final tvCollector = Collector();
  final dummyTv = ConnectedTv(
    name: 'Some Samsung TV',
    modelName: 'UW888',
    id: 'uuid',
    ip: '127.0.0.1',
    wifiMac: '00:00',
  );
  Future<List<ConnectedTv>> _tvsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _tvsFuture = _loadItems();
  }

  Future<List<ConnectedTv>> _loadItems() async {
    List<ConnectedTv> tvs = await tvCollector.collect();
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Select a TV'),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder<List<ConnectedTv>>(
          future: _tvsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 14),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading TVs'),
              );
            } else if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  final tv = items[index];
                  return CupertinoListTile.notched(
                    title: Text(
                      tv.name,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      tv.modelName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: const Icon(Icons.tv, size: 24),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onTapCallback(tv);
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No TVs found'));
            }
          },
        ),
      ),
    );
  }
}
