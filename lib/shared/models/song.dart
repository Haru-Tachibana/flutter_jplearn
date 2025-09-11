import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Song {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String artist;
  
  @HiveField(3)
  final String? albumArt;
  
  @HiveField(4)
  final Duration duration;
  
  @HiveField(5)
  final List<VideoSource> videoSources;
  
  @HiveField(6)
  final JLPTLevel difficulty;
  
  @HiveField(7)
  final List<String> tags;
  
  @HiveField(8)
  final DateTime? lastPlayed;
  
  @HiveField(9)
  final bool isDownloaded;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.albumArt,
    required this.duration,
    required this.videoSources,
    required this.difficulty,
    required this.tags,
    this.lastPlayed,
    this.isDownloaded = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
  Map<String, dynamic> toJson() => _$SongToJson(this);
}

@HiveType(typeId: 1)
enum VideoSource {
  @HiveField(0)
  bilibili,
  @HiveField(1)
  qqMusic,
  @HiveField(2)
  neteaseMusic,
  @HiveField(3)
  local,
}

@HiveType(typeId: 2)
enum JLPTLevel {
  @HiveField(0)
  n5,
  @HiveField(1)
  n4,
  @HiveField(2)
  n3,
  @HiveField(3)
  n2,
  @HiveField(4)
  n1,
}