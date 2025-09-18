import 'package:flutter/material.dart';
import 'package:jpsong_learn/shared/models/song.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget to show a Song in a card, with album art, title, artist, level, and Spotify button
class SongCard extends StatelessWidget {
  final Song song;

  const SongCard({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        leading: song.albumArt != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  song.albumArt!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) =>
                      const Icon(Icons.music_note, size: 32),
                ),
              )
            : const Icon(Icons.music_note, size: 32),
        title: Text(
          song.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade50,
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse("https://open.spotify.com/track/${song.id}");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 10),
              ),
              child: const Text("Spotify"),
            ),
          ],
        ),
      ),
    );
  }
}