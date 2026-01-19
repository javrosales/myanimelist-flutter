import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class RoleList extends StatelessWidget {
  const RoleList(this.list);

  final BuiltList<VoiceActor> list;

  @override
  Widget build(BuildContext context) {
    BuiltList<VoiceActor> shortList = list.length > 50 ? BuiltList(list.where((i) => i.role == 'Main').take(50)) : list;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Voice Acting Roles', style: Theme.of(context).textTheme.titleMedium),
              if (list.length > 50)
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'View all',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullRoleList(list),
                        settings: const RouteSettings(name: 'VoiceActingRolesScreen'),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        Column(children: shortList.map((actor) => RoleItem(actor)).toList()),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class FullRoleList extends StatelessWidget {
  const FullRoleList(this.actors);

  final BuiltList<VoiceActor> actors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Acting Roles')),
      body: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          itemCount: actors.length,
          itemBuilder: (context, index) => RoleItem(actors[index]),
        ),
      ),
    );
  }
}

class RoleItem extends StatelessWidget {
  const RoleItem(this.actor);

  final VoiceActor actor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: <Widget>[
          TitleAnime(
            actor.anime.malId,
            actor.anime.title,
            actor.anime.imageUrl,
            width: kImageWidthS,
            height: kImageHeightS,
            type: ItemType.anime,
            showTitle: false,
          ),
          const SizedBox(width: 8.0),
          Expanded(child: Text(actor.anime.title)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Text>[
                Text(actor.character.name, textAlign: TextAlign.end),
                Text(actor.role, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          TitleAnime(
            actor.character.malId,
            '',
            actor.character.imageUrl,
            width: kImageWidthS,
            height: kImageHeightS,
            type: ItemType.characters,
          ),
        ],
      ),
    );
  }
}
