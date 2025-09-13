import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  String _searchQuery = '';
  bool _isSearching = false;
  String _selectedSource = 'All';
  String _selectedDifficulty = 'All';

  // Sample search results
  final List<Map<String, dynamic>> searchResults = [
    {
      'id': '1',
      'title': '夜に駆ける',
      'artist': 'YOASOBI',
      'duration': '3:17',
      'difficulty': 'N3',
      'albumArt': null,
      'source': 'Bilibili',
      'views': '150M',
      'isInLibrary': false,
      'hasLyrics': true,
      'tags': ['pop', 'anime'],
    },
    {
      'id': '2',
      'title': '炎',
      'artist': 'LiSA',
      'duration': '4:19',
      'difficulty': 'N2',
      'albumArt': null,
      'source': 'QQ Music',
      'views': '89M',
      'isInLibrary': true,
      'hasLyrics': true,
      'tags': ['anime', 'rock'],
    },
    {
      'id': '3',
      'title': '紅蓮華',
      'artist': 'LiSA',
      'duration': '4:04',
      'difficulty': 'N2',
      'albumArt': null,
      'source': 'Netease Music',
      'views': '200M',
      'isInLibrary': false,
      'hasLyrics': true,
      'tags': ['anime', 'rock'],
    },
    {
      'id': '4',
      'title': 'Lemon',
      'artist': '米津玄師',
      'duration': '4:15',
      'difficulty': 'N4',
      'albumArt': null,
      'source': 'Bilibili',
      'views': '300M',
      'isInLibrary': true,
      'hasLyrics': true,
      'tags': ['pop', 'ballad'],
    },
    {
      'id': '5',
      'title': '白日',
      'artist': 'King Gnu',
      'duration': '4:39',
      'difficulty': 'N3',
      'albumArt': null,
      'source': 'QQ Music',
      'views': '120M',
      'isInLibrary': false,
      'hasLyrics': true,
      'tags': ['rock', 'alternative'],
    },
  ];

  final List<String> popularSearches = [
    'YOASOBI',
    'LiSA',
    '米津玄師',
    'King Gnu',
    'あいみょん',
    'Official髭男dism',
    'RADWIMPS',
    '宇多田ヒカル',
  ];

  final List<String> trendingTags = [
    'anime',
    'pop',
    'rock',
    'ballad',
    'j-pop',
    'vocaloid',
    'idol',
    'folk',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
    });
  }

  List<Map<String, dynamic>> get filteredResults {
    if (_searchQuery.isEmpty) return [];

    var filtered = searchResults.where((song) {
      final matchesQuery = song['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          song['artist']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesSource = _selectedSource == 'All' ||
          song['source'].toString().contains(_selectedSource);

      final matchesDifficulty = _selectedDifficulty == 'All' ||
          song['difficulty'] == _selectedDifficulty;

      return matchesQuery && matchesSource && matchesDifficulty;
    }).toList();

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(scheme),
            if (_isSearching) ...[
              _buildFilters(scheme),
              Expanded(child: _buildSearchResults(scheme)),
            ] else ...[
              _buildTabBar(scheme),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDiscoverTab(scheme),
                    _buildTrendingTab(scheme),
                    _buildGenresTab(scheme),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Music',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search songs, artists...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                      )
                    : null,
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(ColorScheme scheme) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Source', _selectedSource, [
                    'All', 'Bilibili', 'QQ Music', 'Netease Music'
                  ], (value) {
                    setState(() => _selectedSource = value);
                  }, scheme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Difficulty', _selectedDifficulty, [
                    'All', 'N5', 'N4', 'N3', 'N2', 'N1'
                  ], (value) {
                    setState(() => _selectedDifficulty = value);
                  }, scheme),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showAdvancedFilters(context, scheme),
            icon: Icon(Icons.tune, color: scheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onSelected,
    ColorScheme scheme,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map((option) => PopupMenuItem(
                value: option,
                child: Row(
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        if (value != null) onSelected(value);
                        Navigator.pop(context);
                      },
                      activeColor: scheme.primary,
                    ),
                    Text(option),
                  ],
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selectedValue != 'All' ? scheme.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $selectedValue',
              style: TextStyle(
                color: selectedValue != 'All' ? Colors.white : Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: selectedValue != 'All' ? Colors.white : Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(ColorScheme scheme) {
    final results = filteredResults;

    if (results.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoResults(scheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _buildSongCard(results[index], scheme);
      },
    );
  }

  Widget _buildSongCard(Map<String, dynamic> song, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showSongPreview(context, song, scheme);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Album Art
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: song['albumArt'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          song['albumArt'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            song['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (song['isInLibrary'])
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: scheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song['artist'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Metadata Row
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          song['duration'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.remove_red_eye,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          song['views'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(song['difficulty']),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            song['difficulty'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Action Button
              IconButton(
                onPressed: () {
                  if (song['isInLibrary']) {
                    _removeFromLibrary(song);
                  } else {
                    _addToLibrary(song);
                  }
                },
                icon: Icon(
                  song['isInLibrary'] ? Icons.remove_circle : Icons.add_circle,
                  color: song['isInLibrary'] ? Colors.grey[600] : scheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Discover'),
          Tab(text: 'Trending'),
          Tab(text: 'Genres'),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Searches
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches
                .map((search) => _buildSearchChip(search, scheme))
                .toList(),
          ),
          const SizedBox(height: 24),

          // Recommended for Beginners
          const Text(
            'Recommended for Beginners',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final beginnerSongs = searchResults
                    .where((song) => song['difficulty'] == 'N5' || song['difficulty'] == 'N4')
                    .take(3)
                    .toList();
                if (index < beginnerSongs.length) {
                  return _buildHorizontalSongCard(beginnerSongs[index], scheme);
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 24),

          // Recently Added
          const Text(
            'Recently Added',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...searchResults.take(3).map((song) => _buildSongCard(song, scheme)),
        ],
      ),
    );
  }

  Widget _buildTrendingTab(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trending Now
          Row(
            children: [
              Icon(Icons.trending_up, color: scheme.primary),
              const SizedBox(width: 8),
              const Text(
                'Trending Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...searchResults.map((song) => _buildTrendingSongCard(song, scheme)),
        ],
      ),
    );
  }

  Widget _buildGenresTab(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Browse by Genre',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: trendingTags.length,
            itemBuilder: (context, index) {
              return _buildGenreCard(trendingTags[index], scheme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String search, ColorScheme scheme) {
    return GestureDetector(
      onTap: () {
        _searchController.text = search;
        setState(() {
          _searchQuery = search;
          _isSearching = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          search,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSongCard(Map<String, dynamic> song, ColorScheme scheme) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => _showSongPreview(context, song, scheme),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    color: scheme.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                song['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                song['artist'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(song['difficulty']),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      song['difficulty'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      if (song['isInLibrary']) {
                        _removeFromLibrary(song);
                      } else {
                        _addToLibrary(song);
                      }
                    },
                    icon: Icon(
                      song['isInLibrary'] ? Icons.check_circle : Icons.add_circle_outline,
                      size: 20,
                      color: song['isInLibrary'] ? scheme.primary : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSongCard(Map<String, dynamic> song, ColorScheme scheme) {
    final rank = searchResults.indexOf(song) + 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => _showSongPreview(context, song, scheme),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: rank <= 3 ? scheme.primary : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      color: rank <= 3 ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Album Art
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.music_note,
                  color: scheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Song Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song['artist'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Views
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    song['views'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'views',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(String genre, ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withOpacity(0.8),
            scheme.secondary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _searchController.text = genre;
          setState(() {
            _searchQuery = genre;
            _isSearching = true;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getGenreIcon(genre),
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                genre.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No songs found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedSource = 'All';
                _selectedDifficulty = 'All';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'N5': return Colors.green;
      case 'N4': return Colors.lightGreen;
      case 'N3': return Colors.orange;
      case 'N2': return Colors.deepOrange;
      case 'N1': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'anime': return Icons.tv;
      case 'pop': return Icons.music_note;
      case 'rock': return Icons.music_video;
      case 'ballad': return Icons.favorite;
      case 'j-pop': return Icons.star;
      case 'vocaloid': return Icons.android;
      case 'idol': return Icons.group;
      case 'folk': return Icons.nature;
      default: return Icons.music_note;
    }
  }

  void _addToLibrary(Map<String, dynamic> song) {
    setState(() {
      song['isInLibrary'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song['title']} added to library'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'PLAY',
          onPressed: () {
            // Navigate to player
          },
        ),
      ),
    );
  }

  void _removeFromLibrary(Map<String, dynamic> song) {
    setState(() {
      song['isInLibrary'] = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song['title']} removed from library'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSongPreview(BuildContext context, Map<String, dynamic> song, ColorScheme scheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Song Header
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: scheme.primary,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song['artist'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(song['difficulty']),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    song['difficulty'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (song['hasLyrics'])
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'LYRICS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  // Song Details
                  _buildDetailRow('Duration', song['duration']),
                  _buildDetailRow('Source', song['source']),
                  _buildDetailRow('Views', song['views']),
                  if (song['tags'] != null)
                    _buildDetailRow('Tags', (song['tags'] as List).join(', ')),

                  const SizedBox(height: 24),

                  // Preview Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.primary.withOpacity(0.3)),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Play preview
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle, color: scheme.primary, size: 30),
                          const SizedBox(width: 12),
                          Text(
                            'Play Preview',
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            if (song['isInLibrary']) {
                              _removeFromLibrary(song);
                            } else {
                              _addToLibrary(song);
                            }
                          },
                          icon: Icon(
                            song['isInLibrary'] 
                                ? Icons.remove_circle 
                                : Icons.library_add,
                          ),
                          label: Text(
                            song['isInLibrary'] 
                                ? 'Remove from Library' 
                                : 'Add to Library',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: song['isInLibrary'] 
                                ? Colors.grey[600] 
                                : scheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerScreen(
                                songTitle: song['title'],
                                artist: song['artist'],
                                albumArt: song['albumArt'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Additional Info
                  if (song['hasLyrics']) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.translate, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Learning Features Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'This song includes synchronized lyrics with furigana, romaji, and translations.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Related Songs
                  const Text(
                    'More from this Artist',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final relatedSongs = searchResults
                            .where((s) => s['artist'] == song['artist'] && s['id'] != song['id'])
                            .take(3)
                            .toList();
                        if (index < relatedSongs.length) {
                          return _buildRelatedSongCard(relatedSongs[index], scheme);
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedSongCard(Map<String, dynamic> song, ColorScheme scheme) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showSongPreview(context, song, scheme);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    color: scheme.primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                song['title'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdvancedFilters(BuildContext context, ColorScheme scheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Filters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Has Lyrics Filter
            SwitchListTile(
              title: const Text('Has Lyrics'),
              subtitle: const Text('Show only songs with synchronized lyrics'),
              value: true,
              onChanged: (value) {},
              activeColor: scheme.primary,
            ),

            // In Library Filter
            SwitchListTile(
              title: const Text('Not in Library'),
              subtitle: const Text('Show only songs not yet added'),
              value: false,
              onChanged: (value) {},
              activeColor: scheme.primary,
            ),

            // Duration Filter
            const Text(
              'Duration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                'Any',
                '< 3 min',
                '3-5 min',
                '> 5 min',
              ].map((duration) => Expanded(
                child: RadioListTile<String>(
                  title: Text(duration, style: const TextStyle(fontSize: 12)),
                  value: duration,
                  groupValue: 'Any',
                  onChanged: (value) {},
                  activeColor: scheme.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              )).toList(),
            ),

            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset filters
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Import the MusicPlayerScreen from the previous artifact
class MusicPlayerScreen extends StatelessWidget {
  final String songTitle;
  final String artist;
  final String? albumArt;

  const MusicPlayerScreen({
    Key? key,
    required this.songTitle,
    required this.artist,
    this.albumArt,
  }) : super(key: key);

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
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.music_note,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              songTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'by $artist',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Full music player with lyrics would be implemented here',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}