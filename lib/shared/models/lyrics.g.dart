// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricsDataAdapter extends TypeAdapter<LyricsData> {
  @override
  final int typeId = 3;

  @override
  LyricsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricsData(
      songId: fields[0] as String,
      lines: (fields[1] as List).cast<LyricsLine>(),
      lastUpdated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LyricsData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.lines)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LyricsLineAdapter extends TypeAdapter<LyricsLine> {
  @override
  final int typeId = 4;

  @override
  LyricsLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricsLine(
      id: fields[0] as String,
      startTime: fields[1] as Duration,
      endTime: fields[2] as Duration,
      originalText: fields[3] as String,
      hiraganaText: fields[4] as String,
      romajiText: fields[5] as String,
      chineseTranslation: fields[6] as String,
      segments: (fields[7] as List).cast<WordSegment>(),
      isLearned: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LyricsLine obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.originalText)
      ..writeByte(4)
      ..write(obj.hiraganaText)
      ..writeByte(5)
      ..write(obj.romajiText)
      ..writeByte(6)
      ..write(obj.chineseTranslation)
      ..writeByte(7)
      ..write(obj.segments)
      ..writeByte(8)
      ..write(obj.isLearned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricsLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LyricsData _$LyricsDataFromJson(Map<String, dynamic> json) => LyricsData(
      songId: json['songId'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => LyricsLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$LyricsDataToJson(LyricsData instance) =>
    <String, dynamic>{
      'songId': instance.songId,
      'lines': instance.lines,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

LyricsLine _$LyricsLineFromJson(Map<String, dynamic> json) => LyricsLine(
      id: json['id'] as String,
      startTime: Duration(microseconds: (json['startTime'] as num).toInt()),
      endTime: Duration(microseconds: (json['endTime'] as num).toInt()),
      originalText: json['originalText'] as String,
      hiraganaText: json['hiraganaText'] as String,
      romajiText: json['romajiText'] as String,
      chineseTranslation: json['chineseTranslation'] as String,
      segments: (json['segments'] as List<dynamic>)
          .map((e) => WordSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLearned: json['isLearned'] as bool? ?? false,
    );

Map<String, dynamic> _$LyricsLineToJson(LyricsLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.inMicroseconds,
      'endTime': instance.endTime.inMicroseconds,
      'originalText': instance.originalText,
      'hiraganaText': instance.hiraganaText,
      'romajiText': instance.romajiText,
      'chineseTranslation': instance.chineseTranslation,
      'segments': instance.segments,
      'isLearned': instance.isLearned,
    };
