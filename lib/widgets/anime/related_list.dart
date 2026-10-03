import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';

class RelatedList extends StatelessWidget {
  const RelatedList(this.relations);

  final BuiltList<Relation> relations;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> related = [];
    for (final relation in relations) {
      for (final entry in relation.entry) {
        related.add({'entry': entry, 'relation': relation.relation});
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Related Entries', style: Theme.of(context).textTheme.titleMedium),
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
                  item['entry'].malId,
                  item['entry'].title,
                  item['relation'],
                  item['entry'].imageUrl,
                  type: item['entry'].url.contains('/anime/') ? ItemType.anime : ItemType.manga,
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
