import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jpsong_learn/shared/models/song.dart';
import 'spotify_auth.dart';

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<Song>>>(
  (ref) => SearchNotifier(),
);

class SearchNotifier extends StateNotifier<AsyncValue<List<Song>>> {
  SearchNotifier() : super(const AsyncValue.data([]));

  final SpotifyAuth _auth = SpotifyAuth();

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    state = const AsyncValue.loading();

    try {
      // Get token dynamically
      final token = await _auth.getToken();
      final response = await http.get(
        Uri.parse(
            "https://api.spotify.com/v1/search?q=$query&type=track&limit=10"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = (data['tracks']['items'] as List).map((t) {
          return Song(
            id: t['id'],
            title: t['name'],
            artist: (t['artists'] as List)
                .map((a) => a['name'])
                .join(", "),
            albumArt: t['album']['images'].isNotEmpty
                ? t['album']['images'][0]['url']
                : null,
            duration: Duration(milliseconds: t['duration_ms']),
            videoSources: [],
            tags: [],
          );
        }).toList();

        state = AsyncValue.data(tracks.cast<Song>());
      } else {
        state =
            AsyncValue.error("Error: ${response.body}", StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
