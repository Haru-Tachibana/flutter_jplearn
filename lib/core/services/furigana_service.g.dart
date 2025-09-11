// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furigana_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordSegmentAdapter extends TypeAdapter<WordSegment> {
  @override
  final int typeId = 5;

  @override
  WordSegment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordSegment(
      surface: fields[0] as String,
      reading: fields[1] as String,
      partOfSpeech: fields[2] as String,
      meaning: fields[3] as String,
      jlptLevel: fields[4] as JLPTLevel,
      isKnown: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WordSegment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.surface)
      ..writeByte(1)
      ..write(obj.reading)
      ..writeByte(2)
      ..write(obj.partOfSpeech)
      ..writeByte(3)
      ..write(obj.meaning)
      ..writeByte(4)
      ..write(obj.jlptLevel)
      ..writeByte(5)
      ..write(obj.isKnown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSegmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JLPTLevelAdapter extends TypeAdapter<JLPTLevel> {
  @override
  final int typeId = 10;

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
      case 5:
        return JLPTLevel.unknown;
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
      case JLPTLevel.unknown:
        writer.writeByte(5);
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

WordSegment _$WordSegmentFromJson(Map<String, dynamic> json) => WordSegment(
      surface: json['surface'] as String,
      reading: json['reading'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      meaning: json['meaning'] as String,
      jlptLevel: $enumDecode(_$JLPTLevelEnumMap, json['jlptLevel']),
      isKnown: json['isKnown'] as bool? ?? false,
    );

Map<String, dynamic> _$WordSegmentToJson(WordSegment instance) =>
    <String, dynamic>{
      'surface': instance.surface,
      'reading': instance.reading,
      'partOfSpeech': instance.partOfSpeech,
      'meaning': instance.meaning,
      'jlptLevel': _$JLPTLevelEnumMap[instance.jlptLevel]!,
      'isKnown': instance.isKnown,
    };

const _$JLPTLevelEnumMap = {
  JLPTLevel.n5: 'n5',
  JLPTLevel.n4: 'n4',
  JLPTLevel.n3: 'n3',
  JLPTLevel.n2: 'n2',
  JLPTLevel.n1: 'n1',
  JLPTLevel.unknown: 'unknown',
};
