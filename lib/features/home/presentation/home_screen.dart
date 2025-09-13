import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the search screen and other screens
// In a real project, these would be in separate files
// For now, we'll assume they're available

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // This would be imported from the search_screen.dart file
    return const Scaffold(
      body: Center(
        child: Text('Search Screen - Import from search_screen.dart'),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> recentSongs = [
    {
      'title': 'Lemon',
      'artist': '米津玄師 (Kenshi Yonezu)',
      'difficulty': 'N4',
      'albumArt': null,
      'progress': 0.7,
    },
    {
      'title': 'Pretender',
      'artist': 'Official髭男dism',
      'difficulty': 'N3',
      'albumArt': null,
      'progress': 0.3,
    },
    {
      'title': 'なんでもないや',
      'artist': 'RADWIMPS',
      'difficulty': 'N2',
      'albumArt': null,
      'progress': 0.9,
    },
  ];

  List<Map<String, String>> suggestions = [
    {'title': '夜に駆ける', 'artist': 'YOASOBI'},
    {'title': '炎', 'artist': 'LiSA'},
    {'title': '紅蓮華', 'artist': 'LiSA'},
    {'title': '白日', 'artist': 'King Gnu'},
  ];

  void _onSearchChanged(String query) {
    // Implement search logic here
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(scheme),
          _buildLibraryTab(scheme),
          _buildProgressTab(scheme),
          _buildNotesTab(scheme),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: scheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined),
            activeIcon: Icon(Icons.note),
            label: 'Notes',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(ColorScheme scheme) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar with Search
          SliverAppBar(
            expandedHeight: 120,
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
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search songs, artists...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recently Played Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Continue Learning',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...recentSongs.map((song) => _buildSongCard(song, scheme)),
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Discover New Songs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...suggestions.map((song) => _buildSuggestionCard(song, scheme)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongCard(Map<String, dynamic> song, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                songTitle: song['title']!,
                artist: song['artist']!,
                progress: song['progress'] ?? 0.0,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Album Art Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.music_note,
                  color: scheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              
              // Song Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song['artist']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: song['progress'],
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Difficulty Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  song['difficulty']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, String> song, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.grey[400],
            size: 24,
          ),
        ),
        title: Text(
          song['title']!,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(song['artist']!),
        trailing: Icon(
          Icons.add_circle_outline,
          color: scheme.primary,
        ),
        onTap: () {
          // Add to library logic
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLibraryTab(ColorScheme scheme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Library',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true, scheme),
                  _buildFilterChip('N5', false, scheme),
                  _buildFilterChip('N4', false, scheme),
                  _buildFilterChip('N3', false, scheme),
                  _buildFilterChip('N2', false, scheme),
                  _buildFilterChip('N1', false, scheme),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: recentSongs.length,
                itemBuilder: (context, index) {
                  return _buildLibrarySongCard(recentSongs[index], scheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Filter logic
        },
        backgroundColor: Colors.grey[100],
        selectedColor: scheme.primary.withOpacity(0.2),
        checkmarkColor: scheme.primary,
      ),
    );
  }

  Widget _buildLibrarySongCard(Map<String, dynamic> song, ColorScheme scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.music_note,
            color: scheme.primary,
          ),
        ),
        title: Text(
          song['title']!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(song['artist']!),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'remove',
              child: Text('Remove from Library'),
            ),
            const PopupMenuItem(
              value: 'download',
              child: Text('Download'),
            ),
          ],
          onSelected: (value) {
            if (value == 'remove') {
              setState(() {
                recentSongs.remove(song);
              });
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                songTitle: song['title']!,
                artist: song['artist']!,
                progress: song['progress'] ?? 0.0,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressTab(ColorScheme scheme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Progress',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Stats cards
            Row(
              children: [
                Expanded(child: _buildStatCard('Songs Learned', '12', scheme)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Words Known', '248', scheme)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Study Streak', '7 days', scheme)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Time Spent', '2.5h', scheme)),
              ],
            ),
            const SizedBox(height: 32),
            
            const Text(
              'JLPT Level Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Progress bars for each JLPT level
            _buildJLPTProgress('N5', 0.8, scheme),
            _buildJLPTProgress('N4', 0.6, scheme),
            _buildJLPTProgress('N3', 0.4, scheme),
            _buildJLPTProgress('N2', 0.2, scheme),
            _buildJLPTProgress('N1', 0.1, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJLPTProgress(String level, double progress, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              level,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(ColorScheme scheme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Vocabulary Notes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add new word
                  },
                  icon: Icon(Icons.add, color: scheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Start flashcard review
                    },
                    icon: const Icon(Icons.quiz),
                    label: const Text('Review Flashcards'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // View all notes
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('All Notes'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Recent Words',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildVocabCard(index, scheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabCard(int index, ColorScheme scheme) {
    List<Map<String, String>> words = [
      {'word': '愛', 'reading': 'あい', 'meaning': 'love'},
      {'word': '友達', 'reading': 'ともだち', 'meaning': 'friend'},
      {'word': '学校', 'reading': 'がっこう', 'meaning': 'school'},
      {'word': '音楽', 'reading': 'おんがく', 'meaning': 'music'},
      {'word': '時間', 'reading': 'じかん', 'meaning': 'time'},
    ];

    final word = words[index];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word['word']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word['reading']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word['meaning']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Mark as known/unknown
              },
              icon: Icon(
                Icons.star_border,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerScreen extends StatelessWidget {
  final String songTitle;
  final String artist;
  final double progress;
  
  const PlayerScreen({
    super.key,
    required this.songTitle,
    required this.artist,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(songTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Player screen for $songTitle',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'by $artist',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Progress: ${(progress * 100).toInt()}%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}