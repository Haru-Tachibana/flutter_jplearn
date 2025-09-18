// lib/features/home/presentation/home_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpsong_learn/features/search/services/search_provider.dart';
import 'package:jpsong_learn/shared/widgets/song_card.dart';
//import 'package:jpsong_learn/shared/models/song.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final searchResults = ref.watch(searchProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: true,
            pinned: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'おはよう！',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search songs, artists...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          filled: true,
                        ),
                        onSubmitted: (query) {
                          ref.read(searchProvider.notifier).search(query);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Results Section
          SliverList(
            delegate: SliverChildListDelegate(
              [
                searchResults.when(
                  data: (songs) {
                    if (songs.isEmpty) return const SizedBox.shrink(); // no results

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            'Search Results',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...songs.map((song) => SongCard(song: song)).toList(),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Error: $err'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 