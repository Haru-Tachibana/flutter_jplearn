// lib/core/services/spotify_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jpsong_learn/shared/models/song.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpotifyService {
  static final _clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
  static final _clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
  static String? _accessToken;

  static Future<void> _authenticate() async {
    final creds = base64Url.encode(utf8.encode("$_clientId:$_clientSecret"));

    final response = await http.post(
      Uri.parse("https://accounts.spotify.com/api/token"),
      headers: {
        "Authorization": "Basic $creds",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {"grant_type": "client_credentials"},
    );

    final data = jsonDecode(response.body);
    _accessToken = data["access_token"];
  }

  static Future<List<Song>> searchSongs(String query) async {
    if (_accessToken == null) {
      await _authenticate();
    }

    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/search?q=$query&type=track&limit=10"),
      headers: {"Authorization": "Bearer $_accessToken"},
    );

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final items = data['tracks']['items'] as List;

    return items.map((track) {
      return Song(
        id: track['id'],
        title: track['name'],
        artist: (track['artists'] as List).map((a) => a['name']).join(", "),
        albumArt: track['album']['images'].isNotEmpty
            ? track['album']['images'][0]['url']
            : null,
        duration: Duration(milliseconds: track['duration_ms']),
        videoSources: [],
        tags: [],
      );
    }).toList();
  }
}
