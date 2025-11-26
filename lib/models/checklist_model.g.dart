// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceChecklistItemAdapter extends TypeAdapter<ServiceChecklistItem> {
  @override
  final int typeId = 1;

  @override
  ServiceChecklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceChecklistItem(
      id: fields[0] as String,
      description: fields[1] as String,
      isCompleted: fields[2] as bool,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceChecklistItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceChecklistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChemicalReadingAdapter extends TypeAdapter<ChemicalReading> {
  @override
  final int typeId = 2;

  @override
  ChemicalReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChemicalReading(
      waterBody: fields[0] as WaterBodyType,
      chlorine: fields[1] as double?,
      ph: fields[2] as double?,
      hardness: fields[3] as double?,
      alkalinity: fields[4] as double?,
      cyanuricAcid: fields[5] as double?,
      temperature: fields[6] as double?,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChemicalReading obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.waterBody)
      ..writeByte(1)
      ..write(obj.chlorine)
      ..writeByte(2)
      ..write(obj.ph)
      ..writeByte(3)
      ..write(obj.hardness)
      ..writeByte(4)
      ..write(obj.alkalinity)
      ..writeByte(5)
      ..write(obj.cyanuricAcid)
      ..writeByte(6)
      ..write(obj.temperature)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChemicalReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChecklistPhotoAdapter extends TypeAdapter<ChecklistPhoto> {
  @override
  final int typeId = 3;

  @override
  ChecklistPhoto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistPhoto(
      id: fields[0] as String,
      type: fields[1] as PhotoType,
      localPath: fields[2] as String,
      serverUrl: fields[3] as String?,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
      timestamp: fields[6] as DateTime,
      uploaded: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistPhoto obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.localPath)
      ..writeByte(3)
      ..write(obj.serverUrl)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.uploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistPhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceChecklistAdapter extends TypeAdapter<ServiceChecklist> {
  @override
  final int typeId = 4;

  @override
  ServiceChecklist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceChecklist(
      id: fields[0] as String,
      locationId: fields[1] as int,
      userId: fields[2] as int,
      date: fields[3] as DateTime,
      items: (fields[4] as List).cast<ServiceChecklistItem>(),
      chemicalReadings: (fields[5] as List).cast<ChemicalReading>(),
      suppliesNeeded: (fields[6] as List).cast<String>(),
      photos: (fields[7] as List).cast<ChecklistPhoto>(),
      poolGateLocked: fields[8] as bool,
      notes: fields[9] as String?,
      submitted: fields[10] as bool,
      submittedAt: fields[11] as DateTime?,
      synced: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceChecklist obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.locationId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.chemicalReadings)
      ..writeByte(6)
      ..write(obj.suppliesNeeded)
      ..writeByte(7)
      ..write(obj.photos)
      ..writeByte(8)
      ..write(obj.poolGateLocked)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.submitted)
      ..writeByte(11)
      ..write(obj.submittedAt)
      ..writeByte(12)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceChecklistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
