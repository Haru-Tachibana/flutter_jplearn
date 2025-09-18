// lib/shared/models/song.g.dart

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
      tags: (fields[6] as List).cast<String>(),
      lastPlayed: fields[7] as DateTime?,
      isDownloaded: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.lastPlayed)
      ..writeByte(8)
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      albumArt: json['albumArt'] as String?,
      duration: Duration(microseconds: json['duration'] as int),
      videoSources: (json['videoSources'] as List<dynamic>)
          .map((e) => $enumDecode(_$VideoSourceEnumMap, e))
          .toList(),
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