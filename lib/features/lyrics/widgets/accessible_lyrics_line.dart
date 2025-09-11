import 'package:flutter/material.dart';
// import 'package:flutter/semantics.dart';
import '../domain/lyrics_line.dart'; // Adjust this import path as needed

class AccessibleLyricsLine extends StatelessWidget {
  final LyricsLine line;
  final bool isCurrentLine;
  final bool showFurigana;
  final bool showRomaji;
  final bool showChinese;
  final VoidCallback? onTap;

  const AccessibleLyricsLine({
    Key? key,
    required this.line,
    this.isCurrentLine = false,
    this.showFurigana = true,
    this.showRomaji = true,
    this.showChinese = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final semanticLabel = _buildSemanticLabel();
    
    return Semantics(
      label: semanticLabel,
      hint: 'Tap to play from this line',
      button: true,
      liveRegion: isCurrentLine,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isCurrentLine ? Colors.blue.shade50 : Colors.transparent,
          border: Border.all(
            color: isCurrentLine ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Japanese text with furigana
              if (showFurigana)
                _buildFuriganaText()
              else
                Text(
                  line.originalText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              
              // Romaji
              if (showRomaji)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    line.romajiText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              
              // Chinese translation
              if (showChinese)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    line.chineseTranslation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildSemanticLabel() {
    String label = 'Japanese: ${line.originalText}';
    if (showRomaji) {
      label += ', Romaji: ${line.romajiText}';
    }
    if (showChinese) {
      label += ', Chinese: ${line.chineseTranslation}';
    }
    if (isCurrentLine) {
      label = 'Currently playing: $label';
    }
    return label;
  }

  Widget _buildFuriganaText() {
    // This is a simplified implementation
    // You'll need a proper furigana rendering widget
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        children: _buildFuriganaSpans(),
      ),
    );
  }

  List<TextSpan> _buildFuriganaSpans() {
    // Parse and render furigana annotations
    // This would be implemented based on your furigana format
    return [TextSpan(text: line.originalText)];
  }
}