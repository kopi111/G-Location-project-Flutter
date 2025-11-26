// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_audit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SafetyChecklistItemAdapter extends TypeAdapter<SafetyChecklistItem> {
  @override
  final int typeId = 5;

  @override
  SafetyChecklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SafetyChecklistItem(
      id: fields[0] as String,
      category: fields[1] as String,
      description: fields[2] as String,
      isCompliant: fields[3] as bool,
      notes: fields[4] as String?,
      isRequired: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SafetyChecklistItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompliant)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.isRequired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafetyChecklistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StaffDiscussionAdapter extends TypeAdapter<StaffDiscussion> {
  @override
  final int typeId = 6;

  @override
  StaffDiscussion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StaffDiscussion(
      topic: fields[0] as String,
      confirmed: fields[1] as bool,
      notes: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StaffDiscussion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.topic)
      ..writeByte(1)
      ..write(obj.confirmed)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffDiscussionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SafetyAuditAdapter extends TypeAdapter<SafetyAudit> {
  @override
  final int typeId = 7;

  @override
  SafetyAudit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SafetyAudit(
      id: fields[0] as String,
      locationId: fields[1] as int,
      auditorId: fields[2] as int,
      date: fields[3] as DateTime,
      items: (fields[4] as List).cast<SafetyChecklistItem>(),
      discussions: (fields[5] as List).cast<StaffDiscussion>(),
      staffOnDuty: (fields[6] as List).cast<String>(),
      safetyConcerns: fields[7] as String?,
      submitted: fields[8] as bool,
      submittedAt: fields[9] as DateTime?,
      synced: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SafetyAudit obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.locationId)
      ..writeByte(2)
      ..write(obj.auditorId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.discussions)
      ..writeByte(6)
      ..write(obj.staffOnDuty)
      ..writeByte(7)
      ..write(obj.safetyConcerns)
      ..writeByte(8)
      ..write(obj.submitted)
      ..writeByte(9)
      ..write(obj.submittedAt)
      ..writeByte(10)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafetyAuditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
