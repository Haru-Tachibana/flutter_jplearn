// lib/features/search/presentation/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpsong_learn/features/search/services/search_provider.dart';
import 'package:jpsong_learn/shared/widgets/song_card.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Songs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search songs, artists...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onSubmitted: (query) {
                searchNotifier.search(query); // ✅ real Spotify search
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchState.when(
                data: (songs) {
                  if (songs.isEmpty) {
                    return const Center(
                      child: Text("No songs found. Try searching 🎶"),
                    );
                  }
                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, i) => SongCard(song: songs[i]),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) =>
                    Center(child: Text("Error: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
