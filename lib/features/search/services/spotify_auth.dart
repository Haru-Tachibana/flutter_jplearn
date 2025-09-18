// lib/features/search/services/spotify_auth.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jpsong_learn/env/env.dart';

class SpotifyAuth {
  String? _token;
  DateTime? _expiry;

  Future<String> getToken() async {
    // Return cached token if not expired
    if (_token != null &&
        _expiry != null &&
        DateTime.now().isBefore(_expiry!)) {
      return _token!;
    }

    // Encode client credentials
    final credentials = base64.encode(
      utf8.encode("${Env.spotifyClientId}:${Env.spotifyClientSecret}"),
    );

    // Request new token
    final response = await http.post(
      Uri.parse("https://accounts.spotify.com/api/token"),
      headers: {
        "Authorization": "Basic $credentials",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {"grant_type": "client_credentials"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      _expiry =
          DateTime.now().add(Duration(seconds: data['expires_in'])); // usually 3600
      return _token!;
    } else {
      throw Exception("Failed to get Spotify token: ${response.body}");
    }
  }
}
