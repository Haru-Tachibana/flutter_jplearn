import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
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
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  bool showFurigana = true;
  bool showRomaji = true;
  bool showTranslation = true;
  double currentPosition = 0.3; // 30% through the song
  int currentLineIndex = 2;
  
  late AnimationController _albumArtController;
  late Animation<double> _albumArtAnimation;
  
  // Sample lyrics data
  final List<Map<String, dynamic>> lyrics = [
    {
      'time': 0.0,
      'japanese': '夜に駆ける',
      'furigana': 'よるにかける',
      'romaji': 'yoru ni kakeru',
      'translation': 'Racing into the night',
      'isCurrentLine': false,
    },
    {
      'time': 15.2,
      'japanese': '君とならば',
      'furigana': 'きみとならば',
      'romaji': 'kimi to naraba',
      'translation': 'If it\'s with you',
      'isCurrentLine': false,
    },
    {
      'time': 28.5,
      'japanese': '世界が変わるかもしれない',
      'furigana': 'せかいがかわるかもしれない',
      'romaji': 'sekai ga kawaru kamo shirenai',
      'translation': 'The world might change',
      'isCurrentLine': true,
    },
    {
      'time': 45.8,
      'japanese': 'その声が聞こえる',
      'furigana': 'そのこえがきこえる',
      'romaji': 'sono koe ga kikoeru',
      'translation': 'I can hear that voice',
      'isCurrentLine': false,
    },
    {
      'time': 62.1,
      'japanese': '星空の下で',
      'furigana': 'ほしぞらのしたで',
      'romaji': 'hoshizora no shita de',
      'translation': 'Under the starry sky',
      'isCurrentLine': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _albumArtController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _albumArtAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_albumArtController);
    
    if (isPlaying) {
      _albumArtController.repeat();
    }
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _albumArtController.repeat();
      } else {
        _albumArtController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),
            
            // Album Art and Controls
            Expanded(
              flex: 3,
              child: _buildAlbumSection(scheme),
            ),
            
            // Lyrics Section
            Expanded(
              flex: 4,
              child: _buildLyricsSection(scheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 30,
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) {
              switch (value) {
                case 'add_to_library':
                  // Add to library
                  break;
                case 'download':
                  // Download song
                  break;
                case 'share':
                  // Share song
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_to_library',
                child: Row(
                  children: [
                    Icon(Icons.library_add),
                    SizedBox(width: 12),
                    Text('Add to Library'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 12),
                    Text('Download'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 12),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumSection(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          // Album Art
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedBuilder(
                animation: _albumArtAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _albumArtAnimation.value * 2 * 3.14159,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary.withOpacity(0.8),
                            scheme.secondary.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: widget.albumArt != null
                          ? ClipOval(
                              child: Image.network(
                                widget.albumArt!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.music_note,
                              size: 80,
                              color: Colors.white,
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Song Info
          Text(
            widget.songTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.artist,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Progress Bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: currentPosition,
                  onChanged: (value) {
                    setState(() {
                      currentPosition = value;
                    });
                  },
                  activeColor: scheme.primary,
                  inactiveColor: Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(Duration(seconds: (currentPosition * 180).toInt())),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '3:00',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_previous),
                iconSize: 40,
                color: scheme.primary,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.replay_10),
                iconSize: 35,
                color: Colors.grey[600],
              ),
              Container(
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 40,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.forward_10),
                iconSize: 35,
                color: Colors.grey[600],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_next),
                iconSize: 40,
                color: scheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLyricsSection(ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Lyrics Controls
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Display Options
                Row(
                  children: [
                    const Text(
                      'Display Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _showDisplayOptionsModal(context, scheme);
                      },
                      icon: const Icon(Icons.tune),
                      color: scheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Quick Toggle Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildToggleChip('Furigana', showFurigana, () {
                        setState(() => showFurigana = !showFurigana);
                      }, scheme),
                      const SizedBox(width: 8),
                      _buildToggleChip('Romaji', showRomaji, () {
                        setState(() => showRomaji = !showRomaji);
                      }, scheme),
                      const SizedBox(width: 8),
                      _buildToggleChip('Translation', showTranslation, () {
                        setState(() => showTranslation = !showTranslation);
                      }, scheme),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Lyrics List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: lyrics.length,
              itemBuilder: (context, index) {
                final line = lyrics[index];
                final isCurrentLine = index == currentLineIndex;
                
                return _buildLyricsLine(line, isCurrentLine, scheme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(String label, bool isSelected, VoidCallback onTap, ColorScheme scheme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? scheme.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLyricsLine(Map<String, dynamic> line, bool isCurrentLine, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentLine ? scheme.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentLine 
            ? Border.all(color: scheme.primary, width: 2)
            : Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: isCurrentLine ? [
          BoxShadow(
            color: scheme.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: InkWell(
        onTap: () {
          // Seek to this line
          setState(() {
            currentLineIndex = lyrics.indexOf(line);
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Japanese Text with Furigana
            if (showFurigana) ...[
              _buildFuriganaText(line['japanese'], line['furigana'], isCurrentLine),
              const SizedBox(height: 8),
            ] else ...[
              Text(
                line['japanese'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isCurrentLine ? scheme.primary : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Romaji
            if (showRomaji) ...[
              Text(
                line['romaji'],
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Translation
            if (showTranslation) ...[
              Text(
                line['translation'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
            
            // Add to Notes Button
            const SizedBox(height: 12),
            Row(
              children: [
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    _showAddToNotesDialog(context, line, scheme);
                  },
                  icon: Icon(Icons.note_add, size: 18, color: scheme.primary),
                  label: Text(
                    'Add to Notes',
                    style: TextStyle(color: scheme.primary, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuriganaText(String japanese, String furigana, bool isCurrentLine) {
    // This is a simplified version - in a real app you'd want proper furigana positioning
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          furigana,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        Text(
          japanese,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isCurrentLine ? Theme.of(context).colorScheme.primary : Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showDisplayOptionsModal(BuildContext context, ColorScheme scheme) {
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
              'Display Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            SwitchListTile(
              title: const Text('Show Furigana'),
              subtitle: const Text('Show readings above kanji'),
              value: showFurigana,
              onChanged: (value) {
                setState(() => showFurigana = value);
                Navigator.pop(context);
              },
              activeColor: scheme.primary,
            ),
            
            SwitchListTile(
              title: const Text('Show Romaji'),
              subtitle: const Text('Show romanized pronunciation'),
              value: showRomaji,
              onChanged: (value) {
                setState(() => showRomaji = value);
                Navigator.pop(context);
              },
              activeColor: scheme.primary,
            ),
            
            SwitchListTile(
              title: const Text('Show Translation'),
              subtitle: const Text('Show English translation'),
              value: showTranslation,
              onChanged: (value) {
                setState(() => showTranslation = value);
                Navigator.pop(context);
              },
              activeColor: scheme.primary,
            ),
            
            const SizedBox(height: 20),
            
            ListTile(
              leading: Icon(Icons.speed, color: scheme.primary),
              title: const Text('Playback Speed'),
              subtitle: const Text('Adjust audio speed for learning'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                _showSpeedDialog(context, scheme);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog(BuildContext context, ColorScheme scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playback Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('0.5x'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('0.75x'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('1.0x (Normal)'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('1.25x'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('1.5x'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToNotesDialog(BuildContext context, Map<String, dynamic> line, ColorScheme scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Vocabulary Notes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              line['japanese'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              line['furigana'],
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              line['translation'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Add personal note (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add to vocabulary notes
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to vocabulary notes!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add to Notes'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}