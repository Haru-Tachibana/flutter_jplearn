import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jpsong_learn/core/services/furigana_service.dart';

part 'lyrics.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class LyricsData {
  @HiveField(0)
  final String songId;
  
  @HiveField(1)
  final List<LyricsLine> lines;
  
  @HiveField(2)
  final DateTime lastUpdated;

  const LyricsData({
    required this.songId,
    required this.lines,
    required this.lastUpdated,
  });

  factory LyricsData.fromJson(Map<String, dynamic> json) => _$LyricsDataFromJson(json);
  Map<String, dynamic> toJson() => _$LyricsDataToJson(this);
}

@HiveType(typeId: 4)
@JsonSerializable()
class LyricsLine {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final Duration startTime;
  
  @HiveField(2)
  final Duration endTime;
  
  @HiveField(3)
  final String originalText;
  
  @HiveField(4)
  final String hiraganaText;
  
  @HiveField(5)
  final String romajiText;
  
  @HiveField(6)
  final String chineseTranslation;
  
  @HiveField(7)
  final List<WordSegment> segments;
  
  @HiveField(8)
  final bool isLearned;

  const LyricsLine({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.originalText,
    required this.hiraganaText,
    required this.romajiText,
    required this.chineseTranslation,
    required this.segments,
    this.isLearned = false,
  });

  factory LyricsLine.fromJson(Map<String, dynamic> json) => _$LyricsLineFromJson(json);
  Map<String, dynamic> toJson() => _$LyricsLineToJson(this);
}