import 'package:flutter/material.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';

class CustomFilterV2 extends StatelessWidget {
  const CustomFilterV2(this.username, {this.anime = true});

  final String username;
  final bool anime;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Sort by',
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: anime ? 'anime_title' : 'manga_title', child: const Text('Title')),
          const PopupMenuItem(value: 'list_score', child: Text('Score')),
          PopupMenuItem(value: anime ? 'anime_start_date' : 'manga_start_date', child: const Text('Start Date')),
          const PopupMenuItem(value: 'list_updated_at', child: Text('Last Updated')),
        ];
      },
      onSelected: (value) {
        if (anime) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeListScreen(username, sort: value),
              settings: const RouteSettings(name: 'AnimeListScreen'),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MangaListScreen(username, sort: value),
              settings: const RouteSettings(name: 'MangaListScreen'),
            ),
          );
        }
      },
    );
  }
}
