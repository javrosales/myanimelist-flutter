import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class LaterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Later'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
              Tab(text: 'TV'),
              Tab(text: 'ONA'),
              Tab(text: 'OVA'),
              Tab(text: 'Movie'),
              Tab(text: 'Special'),
              Tab(text: 'Unknown'),
            ],
          ),
          actions: [CustomMenu()],
        ),
        body: FutureBuilder(
          future: getSeasonComplete(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<Anime> animeList = snapshot.data!;
            return TabBarView(
              children: <SeasonList>[
                SeasonList(animeList.where((anime) => anime.type == 'TV').toList()),
                SeasonList(animeList.where((anime) => anime.type == 'ONA').toList()),
                SeasonList(animeList.where((anime) => anime.type == 'OVA').toList()),
                SeasonList(animeList.where((anime) => anime.type == 'Movie').toList()),
                SeasonList(animeList.where((anime) => anime.type == 'Special' || anime.type == 'TV Special').toList()),
                SeasonList(animeList.where((anime) => anime.type == null).toList()),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Anime>> getSeasonComplete() async {
    List<Anime> response = [];
    int page = 0;
    while (page < 4 && response.length == page * 25) {
      response += await jikan.getSeasonUpcoming(page: page + 1);
      page += 1;
    }
    return response;
  }
}
