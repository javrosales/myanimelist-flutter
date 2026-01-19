import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/widgets/season/season_info.dart';
import 'package:provider/provider.dart';

class SeasonList extends StatelessWidget {
  const SeasonList(this.items);

  final List<Anime> items;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (!Provider.of<UserData>(context).kidsGenre) {
      items.removeWhere((anime) => anime.demographics.any((i) => i.name == 'Kids'));
    }
    if (!Provider.of<UserData>(context).r18Genre) {
      items.removeWhere((anime) => anime.genres.any((i) => i.name == 'Hentai' || i.name == 'Erotica'));
    }

    if (items.isEmpty) {
      return const ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: screenWidth < 992.0
          ? ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) => SeasonInfo(items[index]),
            )
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (screenWidth / 2) / 400.0,
              children: items.map((i) => SeasonInfo(i)).toList(),
            ),
    );
  }
}
