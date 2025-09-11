// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 0;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      albumArt: fields[3] as String?,
      duration: fields[4] as Duration,
      videoSources: (fields[5] as List).cast<VideoSource>(),
      difficulty: fields[6] as JLPTLevel,
      tags: (fields[7] as List).cast<String>(),
      lastPlayed: fields[8] as DateTime?,
      isDownloaded: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.albumArt)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.videoSources)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.lastPlayed)
      ..writeByte(9)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceAdapter extends TypeAdapter<VideoSource> {
  @override
  final int typeId = 1;

  @override
  VideoSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VideoSource.bilibili;
      case 1:
        return VideoSource.qqMusic;
      case 2:
        return VideoSource.neteaseMusic;
      case 3:
        return VideoSource.local;
      default:
        return VideoSource.bilibili;
    }
  }

  @override
  void write(BinaryWriter writer, VideoSource obj) {
    switch (obj) {
      case VideoSource.bilibili:
        writer.writeByte(0);
        break;
      case VideoSource.qqMusic:
        writer.writeByte(1);
        break;
      case VideoSource.neteaseMusic:
        writer.writeByte(2);
        break;
      case VideoSource.local:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JLPTLevelAdapter extends TypeAdapter<JLPTLevel> {
  @override
  final int typeId = 2;

  @override
  JLPTLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JLPTLevel.n5;
      case 1:
        return JLPTLevel.n4;
      case 2:
        return JLPTLevel.n3;
      case 3:
        return JLPTLevel.n2;
      case 4:
        return JLPTLevel.n1;
      default:
        return JLPTLevel.n5;
    }
  }

  @override
  void write(BinaryWriter writer, JLPTLevel obj) {
    switch (obj) {
      case JLPTLevel.n5:
        writer.writeByte(0);
        break;
      case JLPTLevel.n4:
        writer.writeByte(1);
        break;
      case JLPTLevel.n3:
        writer.writeByte(2);
        break;
      case JLPTLevel.n2:
        writer.writeByte(3);
        break;
      case JLPTLevel.n1:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JLPTLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      albumArt: json['albumArt'] as String?,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      videoSources: (json['videoSources'] as List<dynamic>)
          .map((e) => $enumDecode(_$VideoSourceEnumMap, e))
          .toList(),
      difficulty: $enumDecode(_$JLPTLevelEnumMap, json['difficulty']),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      lastPlayed: json['lastPlayed'] == null
          ? null
          : DateTime.parse(json['lastPlayed'] as String),
      isDownloaded: json['isDownloaded'] as bool? ?? false,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'albumArt': instance.albumArt,
      'duration': instance.duration.inMicroseconds,
      'videoSources':
          instance.videoSources.map((e) => _$VideoSourceEnumMap[e]!).toList(),
      'difficulty': _$JLPTLevelEnumMap[instance.difficulty]!,
      'tags': instance.tags,
      'lastPlayed': instance.lastPlayed?.toIso8601String(),
      'isDownloaded': instance.isDownloaded,
    };

const _$VideoSourceEnumMap = {
  VideoSource.bilibili: 'bilibili',
  VideoSource.qqMusic: 'qqMusic',
  VideoSource.neteaseMusic: 'neteaseMusic',
  VideoSource.local: 'local',
};

const _$JLPTLevelEnumMap = {
  JLPTLevel.n5: 'n5',
  JLPTLevel.n4: 'n4',
  JLPTLevel.n3: 'n3',
  JLPTLevel.n2: 'n2',
  JLPTLevel.n1: 'n1',
};
