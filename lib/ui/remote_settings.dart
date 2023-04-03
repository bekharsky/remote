import 'package:flutter/material.dart';
import 'package:remote/device/tv_collector.dart';
import 'package:sheet/sheet.dart';

class TvListView extends StatefulWidget {
  const TvListView({super.key});

  @override
  TvListViewState createState() => TvListViewState();
}

class TvListViewState extends State<TvListView> {
  final tvCollector = TvCollector();
  Future<List<Tv>> _tvsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _tvsFuture = _loadItems();
  }

  Future<List<Tv>> _loadItems() async {
    return await tvCollector.collect();
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
                title: Text(snapshot.data?[index].name ?? ''),
                leading: const Icon(Icons.tv),
                onTap: () => Navigator.of(context).pop(),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading items');
        } else {
          return const Text('Loading...');
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
