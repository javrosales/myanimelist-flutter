import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/manga/manga_list.dart';

class AdaptedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manga Adapted to Anime'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: <Tab>[
              Tab(text: 'All'),
              Tab(text: 'Airing Now'),
              Tab(text: 'Upcoming Anime'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <AdaptedList>[
            AdaptedList(),
            AdaptedList(filter: TopFilter.airing),
            AdaptedList(filter: TopFilter.upcoming),
          ],
        ),
      ),
    );
  }
}

class AdaptedList extends StatefulWidget {
  const AdaptedList({this.filter});

  final TopFilter? filter;

  @override
  State<AdaptedList> createState() => _AdaptedListState();
}

class _AdaptedListState extends State<AdaptedList> with AutomaticKeepAliveClientMixin<AdaptedList> {
  late Future<List<Manga>> _future;

  @override
  void initState() {
    super.initState();
    _future = jikan.getMangaAdapted(filter: widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        return MangaList(snapshot.data!);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
