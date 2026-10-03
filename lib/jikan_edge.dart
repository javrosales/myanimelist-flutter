import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jikan_api/jikan_api.dart';

const apiBaseUrl = 'https://jikan.lucashdo.com/v1';

class JikanEdge {
  Future<List<WatchPromo>> getWatchPromos({bool popular = false}) async {
    try {
      var url = popular ? '/watch/promos/popular' : '/watch/promos';
      final response = await http.get(Uri.parse(apiBaseUrl + url));
      final jsonMap = jsonDecode(response.body)['data'] as List<dynamic>;

      return jsonMap.map((item) {
        return WatchPromo.fromJson({
          'title': item['title'],
          'entry': {
            'mal_id': item['animeId'],
            'url': 'https://myanimelist.net/anime/${item['animeId']}',
            'images': {
              'jpg': {'large_image_url': item['imageUrl']},
            },
            'title': item['animeTitle'],
          },
          'trailer': {'embed_url': item['videoUrl']},
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<WatchEpisode>> getWatchEpisodes({bool popular = false}) async {
    try {
      var url = popular ? '/watch/episodes/popular' : '/watch/episodes';
      final response = await http.get(Uri.parse(apiBaseUrl + url));
      final jsonMap = jsonDecode(response.body)['data'] as List<dynamic>;

      return jsonMap.map((item) {
        final int episodeId = int.parse(item['episodes'][0].toString().split(' ').last);
        return WatchEpisode.fromJson({
          'entry': {
            'mal_id': item['animeId'],
            'url': 'https://myanimelist.net/anime/${item['animeId']}',
            'images': {
              'jpg': {'large_image_url': item['imageUrl']},
            },
            'title': item['animeTitle'],
          },
          'episodes': [
            {
              'mal_id': episodeId,
              'url': 'https://myanimelist.net/anime/${item['animeId']}/i/episode/$episodeId',
              'title': item['episodes'][0],
              'premium': true,
            },
          ],
          'region_locked': false,
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<UserProfile?> getUserProfile(String username) async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/users/$username/full'));
      final jsonMap = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      final profile = jsonMap['profile'] as Map<String, dynamic>;
      final statistics = jsonMap['statistics'] as Map<String, dynamic>;
      final favorites = jsonMap['favorites'] as Map<String, dynamic>;
      // final updates = jsonMap['updates'] as Map<String, dynamic>;

      return UserProfile.fromJson({
        'username': profile['username'],
        'url': profile['profileUrl'],
        'images': {
          'jpg': {'image_url': profile['avatarUrl']},
        },
        'last_online': profile['lastOnlineAt'],
        'gender': profile['gender'],
        'birthday': profile['birthday'],
        'location': profile['location'],
        'joined': profile['joinedAt'],
        'statistics': {
          'anime': {
            'days_watched': statistics['anime']['daysWatched'],
            'mean_score': statistics['anime']['meanScore'],
            'watching': statistics['anime']['watching'],
            'completed': statistics['anime']['completed'],
            'on_hold': statistics['anime']['onHold'],
            'dropped': statistics['anime']['dropped'],
            'plan_to_watch': statistics['anime']['planToWatch'],
            'total_entries': statistics['anime']['totalEntries'],
            'rewatched': statistics['anime']['rewatched'],
            'episodes_watched': statistics['anime']['episodesWatched'],
          },
          'manga': {
            'days_read': statistics['manga']['daysRead'],
            'mean_score': statistics['manga']['meanScore'],
            'reading': statistics['manga']['reading'],
            'completed': statistics['manga']['completed'],
            'on_hold': statistics['manga']['onHold'],
            'dropped': statistics['manga']['dropped'],
            'plan_to_read': statistics['manga']['planToRead'],
            'total_entries': statistics['manga']['totalEntries'],
            'reread': statistics['manga']['reread'],
            'chapters_read': statistics['manga']['chaptersRead'],
            'volumes_read': statistics['manga']['volumesRead'],
          },
        },
        'favorites': {
          'anime': (favorites['anime'] as List<dynamic>).map((item) {
            return {
              'mal_id': item['malId'],
              'url': item['url'],
              'images': {
                'jpg': {'large_image_url': item['imageUrl']},
              },
              'title': item['title'],
              'type': item['type'],
              'start_year': item['startYear'],
            };
          }).toList(),
          'manga': (favorites['manga'] as List<dynamic>).map((item) {
            return {
              'mal_id': item['malId'],
              'url': item['url'],
              'images': {
                'jpg': {'large_image_url': item['imageUrl']},
              },
              'title': item['title'],
              'type': item['type'],
              'start_year': item['startYear'],
            };
          }).toList(),
          'characters': (favorites['characters'] as List<dynamic>).map((item) {
            return {
              'mal_id': item['malId'],
              'url': item['url'],
              'images': {
                'jpg': {'image_url': item['imageUrl']},
              },
              'name': item['name'],
            };
          }).toList(),
          'people': (favorites['people'] as List<dynamic>).map((item) {
            return {
              'mal_id': item['malId'],
              'url': item['url'],
              'images': {
                'jpg': {'image_url': item['imageUrl']},
              },
              'name': item['name'],
            };
          }).toList(),
        },
        'updates': null,
        'about': profile['about'],
      });
    } catch (e) {
      return null;
    }
  }
}
