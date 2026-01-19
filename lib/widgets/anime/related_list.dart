import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';

class RelatedList extends StatelessWidget {
  const RelatedList(this.related, {this.anime = true});

  final List<dynamic> related;
  final bool anime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text(
            anime ? 'Related Anime' : 'Related Manga',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: related.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = related.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  item['node']['id'],
                  item['node']['title'],
                  item['relation_type_formatted'],
                  item['node']['main_picture']['large'],
                  type: anime ? ItemType.anime : ItemType.manga,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
