import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Sample vocabulary data
  final List<Map<String, dynamic>> vocabularyNotes = [
    {
      'id': '1',
      'japanese': '愛',
      'furigana': 'あい',
      'romaji': 'ai',
      'meaning': 'love',
      'personalNote': 'Used in many romantic songs',
      'sourceSong': 'Lemon',
      'difficulty': 'N5',
      'reviewStatus': 'learning',
      'accuracy': 0.8,
      'isFavorite': true,
      'tags': ['emotion', 'basic'],
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'nextReviewDate': DateTime.now().add(const Duration(days: 1)),
    },
    {
      'id': '2',
      'japanese': '友達',
      'furigana': 'ともだち',
      'romaji': 'tomodachi',
      'meaning': 'friend',
      'personalNote': 'Common word in youth songs',
      'sourceSong': 'Pretender',
      'difficulty': 'N5',
      'reviewStatus': 'mastered',
      'accuracy': 0.95,
      'isFavorite': false,
      'tags': ['people', 'relationship'],
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
      'nextReviewDate': DateTime.now().add(const Duration(days: 7)),
    },
    {
      'id': '3',
      'japanese': '夜',
      'furigana': 'よる',
      'romaji': 'yoru',
      'meaning': 'night',
      'personalNote': 'Often appears in song titles',
      'sourceSong': '夜に駆ける',
      'difficulty': 'N4',
      'reviewStatus': 'review',
      'accuracy': 0.6,
      'isFavorite': true,
      'tags': ['time', 'nature'],
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'nextReviewDate': DateTime.now(),
    },
    {
      'id': '4',
      'japanese': '世界',
      'furigana': 'せかい',
      'romaji': 'sekai',
      'meaning': 'world',
      'personalNote': 'Abstract concept, often metaphorical',
      'sourceSong': 'なんでもないや',
      'difficulty': 'N3',
      'reviewStatus': 'new_word',
      'accuracy': 0.0,
      'isFavorite': false,
      'tags': ['abstract', 'concept'],
      'createdAt': DateTime.now(),
      'nextReviewDate': DateTime.now(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredVocabulary {
    var filtered = vocabularyNotes.where((word) {
      final matchesSearch = word['japanese']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          word['meaning']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          word['romaji']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesFilter = _selectedFilter == 'All' ||
          word['difficulty'] == _selectedFilter ||
          word['reviewStatus'] == _selectedFilter.toLowerCase().replaceAll(' ', '_');

      return matchesSearch && matchesFilter;
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
            _buildHeader(scheme),
            _buildTabBar(scheme),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVocabularyTab(scheme),
                  _buildFlashcardsTab(scheme),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVocabularyDialog(context, scheme),
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme) {
    return Padding(
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
                onPressed: () => _showStatsDialog(context, scheme),
                icon: Icon(Icons.analytics_outlined, color: scheme.primary),
              ),
              IconButton(
                onPressed: () => _showFilterDialog(context, scheme),
                icon: Icon(Icons.filter_list, color: scheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search vocabulary...',
              prefixIcon: const Icon(Icons.search),
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
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              _buildStatChip('Total: ${vocabularyNotes.length}', scheme),
              const SizedBox(width: 8),
              _buildStatChip('Due Today: ${_getDueTodayCount()}', scheme),
              const SizedBox(width: 8),
              _buildStatChip('Mastered: ${_getMasteredCount()}', scheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: scheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
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
          Tab(text: 'Vocabulary'),
          Tab(text: 'Flashcards'),
        ],
      ),
    );
  }

  Widget _buildVocabularyTab(ColorScheme scheme) {
    final filtered = filteredVocabulary;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Filter chips
          if (_selectedFilter != 'All') ...[
            Row(
              children: [
                Chip(
                  label: Text(_selectedFilter),
                  onDeleted: () {
                    setState(() {
                      _selectedFilter = 'All';
                    });
                  },
                  backgroundColor: scheme.primary.withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: scheme.primary),
                  deleteIconColor: scheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Vocabulary List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(scheme)
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildVocabularyCard(filtered[index], scheme);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyCard(Map<String, dynamic> vocab, ColorScheme scheme) {
    final isOverdue = DateTime.now().isAfter(vocab['nextReviewDate']);
    final needsReview = DateTime.now().isAtSameMomentAs(vocab['nextReviewDate']) || isOverdue;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: needsReview ? scheme.error.withValues(alpha: 0.3) : Colors.grey[200]!,
          width: needsReview ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showVocabularyDetails(context, vocab, scheme),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Japanese word with furigana
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              vocab['japanese'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              vocab['furigana'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        
                        // Romaji
                        Text(
                          vocab['romaji'],
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Meaning
                        Text(
                          vocab['meaning'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Column(
                    children: [
                      // Favorite button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            vocab['isFavorite'] = !vocab['isFavorite'];
                          });
                        },
                        icon: Icon(
                          vocab['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                          color: vocab['isFavorite'] ? Colors.red : Colors.grey,
                        ),
                      ),
                      
                      // Difficulty badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(vocab['difficulty']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vocab['difficulty'],
                          style: const TextStyle(
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
              
              const SizedBox(height: 12),
              
              // Personal note (if exists)
              if (vocab['personalNote'] != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vocab['personalNote'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              // Bottom info row
              Row(
                children: [
                  // Source song
                  if (vocab['sourceSong'] != null) ...[
                    Icon(Icons.music_note, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      vocab['sourceSong'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                  ],
                  
                  // Review status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(vocab['reviewStatus']).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(vocab['reviewStatus']),
                          size: 12,
                          color: _getStatusColor(vocab['reviewStatus']),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(vocab['reviewStatus']),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(vocab['reviewStatus']),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (needsReview) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isOverdue ? 'Overdue' : 'Due Today',
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardsTab(ColorScheme scheme) {
    final dueForReview = vocabularyNotes.where((vocab) {
      return DateTime.now().isAfter(vocab['nextReviewDate']) ||
          DateTime.now().isAtSameMomentAs(vocab['nextReviewDate']);
    }).length;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scheme.primary.withValues(alpha: 0.1),
                  scheme.secondary.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to Review',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$dueForReview cards due for review',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: dueForReview > 0 
                            ? () => _startFlashcardSession(context, 'due', scheme)
                            : null,
                        icon: const Icon(Icons.quiz),
                        label: const Text('Review Due Cards'),
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
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Practice Modes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Practice mode cards
          _buildPracticeModeCard(
            'All Vocabulary',
            'Practice with all your saved words',
            Icons.library_books,
            () => _startFlashcardSession(context, 'all', scheme),
            scheme,
          ),
          
          _buildPracticeModeCard(
            'Favorites Only',
            'Review your starred vocabulary',
            Icons.favorite,
            () => _startFlashcardSession(context, 'favorites', scheme),
            scheme,
          ),
          
          _buildPracticeModeCard(
            'Recently Added',
            'Practice words added this week',
            Icons.schedule,
            () => _startFlashcardSession(context, 'recent', scheme),
            scheme,
          ),
          
          _buildPracticeModeCard(
            'Difficult Words',
            'Focus on words you struggle with',
            Icons.trending_up,
            () => _startFlashcardSession(context, 'difficult', scheme),
            scheme,
          ),
          
          const SizedBox(height: 24),
          
          // Study statistics
          const Text(
            'Study Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildStatRow('Study streak', '7 days', Icons.local_fire_department),
                const Divider(),
                _buildStatRow('Cards reviewed today', '15', Icons.quiz),
                const Divider(),
                _buildStatRow('Average accuracy', '83%', Icons.trending_up),
                const Divider(),
                _buildStatRow('Total study time', '2.5 hours', Icons.access_time),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeModeCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    ColorScheme scheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: scheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No vocabulary notes yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add words from songs or create custom notes',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddVocabularyDialog(context, scheme),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Word'),
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new_word': return Colors.blue;
      case 'learning': return Colors.orange;
      case 'review': return Colors.amber;
      case 'mastered': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'new_word': return Icons.fiber_new;
      case 'learning': return Icons.school;
      case 'review': return Icons.refresh;
      case 'mastered': return Icons.check_circle;
      default: return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new_word': return 'New';
      case 'learning': return 'Learning';
      case 'review': return 'Review';
      case 'mastered': return 'Mastered';
      default: return 'Unknown';
    }
  }

  int _getDueTodayCount() {
    return vocabularyNotes.where((vocab) {
      final reviewDate = vocab['nextReviewDate'] as DateTime;
      final today = DateTime.now();
      return reviewDate.year == today.year &&
          reviewDate.month == today.month &&
          reviewDate.day == today.day;
    }).length;
  }

  int _getMasteredCount() {
    return vocabularyNotes.where((vocab) => vocab['reviewStatus'] == 'mastered').length;
  }

  // Dialog methods
  void _showAddVocabularyDialog(BuildContext context, ColorScheme scheme) {
    final japaneseController = TextEditingController();
    final furiganaController = TextEditingController();
    final romajiController = TextEditingController();
    final meaningController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Vocabulary'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: japaneseController,
                  decoration: const InputDecoration(
                    labelText: 'Japanese',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: furiganaController,
                  decoration: const InputDecoration(
                    labelText: 'Furigana',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: romajiController,
                  decoration: const InputDecoration(
                    labelText: 'Romaji',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: meaningController,
                  decoration: const InputDecoration(
                    labelText: 'Meaning',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Personal Note (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (japaneseController.text.isNotEmpty &&
                  meaningController.text.isNotEmpty) {
                // Add vocabulary logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vocabulary added successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ColorScheme scheme) {
    final filters = [
      'All',
      'N5',
      'N4',
      'N3',
      'N2',
      'N1',
      'New Word',
      'Learning',
      'Review',
      'Mastered',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Vocabulary'),
        content: RadioGroup<String>(
          groupValue: _selectedFilter, // ✅ correct usage
          onChanged: (value) {
            setState(() {
              _selectedFilter = value!; // ✅ fix nullability
            });
            Navigator.pop(context); // close dialog after selecting
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: filters.map((filter) {
              return RadioListTile<String>(
                title: Text(filter),
                value: filter,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }



  void _showStatsDialog(BuildContext context, ColorScheme scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vocabulary Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Total words', '${vocabularyNotes.length}', Icons.library_books),
            const Divider(),
            _buildStatRow('Due today', '${_getDueTodayCount()}', Icons.today),
            const Divider(),
            _buildStatRow('Mastered', '${_getMasteredCount()}', Icons.check_circle),
            const Divider(),
            _buildStatRow('Learning', '${vocabularyNotes.where((v) => v['reviewStatus'] == 'learning').length}', Icons.school),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVocabularyDetails(BuildContext context, Map<String, dynamic> vocab, ColorScheme scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vocab['japanese']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reading: ${vocab['furigana']}'),
            Text('Romaji: ${vocab['romaji']}'),
            Text('Meaning: ${vocab['meaning']}'),
            if (vocab['personalNote'] != null) ...[
              const SizedBox(height: 8),
              Text('Note: ${vocab['personalNote']}'),
            ],
            if (vocab['sourceSong'] != null) ...[
              const SizedBox(height: 8),
              Text('From song: ${vocab['sourceSong']}'),
            ],
            const SizedBox(height: 8),
            Text('Difficulty: ${vocab['difficulty']}'),
            Text('Status: ${_getStatusText(vocab['reviewStatus'])}'),
            Text('Accuracy: ${(vocab['accuracy'] * 100).toInt()}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startFlashcardSession(context, 'single', scheme, specificWord: vocab);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Practice'),
          ),
        ],
      ),
    );
  }

  void _startFlashcardSession(
    BuildContext context,
    String mode,
    ColorScheme scheme, {
    Map<String, dynamic>? specificWord,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardSessionScreen(
          mode: mode,
          vocabularyList: mode == 'single' && specificWord != null
              ? [specificWord]
              : _getVocabularyForMode(mode),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getVocabularyForMode(String mode) {
    switch (mode) {
      case 'due':
        return vocabularyNotes.where((vocab) {
          return DateTime.now().isAfter(vocab['nextReviewDate']) ||
              DateTime.now().isAtSameMomentAs(vocab['nextReviewDate']);
        }).toList();
      case 'favorites':
        return vocabularyNotes.where((vocab) => vocab['isFavorite'] == true).toList();
      case 'recent':
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        return vocabularyNotes.where((vocab) {
          return vocab['createdAt'].isAfter(weekAgo);
        }).toList();
      case 'difficult':
        return vocabularyNotes.where((vocab) => vocab['accuracy'] < 0.7).toList();
      case 'all':
      default:
        return vocabularyNotes;
    }
  }
}

// Placeholder for FlashcardSessionScreen
class FlashcardSessionScreen extends StatelessWidget {
  final String mode;
  final List<Map<String, dynamic>> vocabularyList;

  const FlashcardSessionScreen({
    Key? key,
    required this.mode,
    required this.vocabularyList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Session - ${mode.toUpperCase()}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flashcard session for ${vocabularyList.length} words'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('End Session'),
            ),
          ],
        ),
      ),
    );
  }
}