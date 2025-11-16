import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'checklist_model.g.dart';

/// Water body types for chemical readings
enum WaterBodyType {
  mainPool,
  wadingPool,
  spa,
  other;

  String get displayName {
    switch (this) {
      case WaterBodyType.mainPool:
        return 'Main Pool';
      case WaterBodyType.wadingPool:
        return 'Wading Pool';
      case WaterBodyType.spa:
        return 'Spa';
      case WaterBodyType.other:
        return 'Other';
    }
  }
}

/// Photo requirement types
enum PhotoType {
  mainPoolFullView,
  mainDrain,
  skimmers,
  filterSystem,
  chemicalController;

  String get displayName {
    switch (this) {
      case PhotoType.mainPoolFullView:
        return 'Main Pool - Full View';
      case PhotoType.mainDrain:
        return 'Main Drain';
      case PhotoType.skimmers:
        return 'Skimmers';
      case PhotoType.filterSystem:
        return 'Filter System';
      case PhotoType.chemicalController:
        return 'Chemical Controller';
    }
  }
}

/// Service Technician Checklist Item
@HiveType(typeId: 1)
class ServiceChecklistItem extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool isCompleted;
  @HiveField(3)
  final String? notes;

  const ServiceChecklistItem({
    required this.id,
    required this.description,
    this.isCompleted = false,
    this.notes,
  });

  ServiceChecklistItem copyWith({
    String? id,
    String? description,
    bool? isCompleted,
    String? notes,
  }) {
    return ServiceChecklistItem(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  factory ServiceChecklistItem.fromJson(Map<String, dynamic> json) {
    return ServiceChecklistItem(
      id: json['id'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, description, isCompleted, notes];
}

/// Chemical Reading data
@HiveType(typeId: 2)
class ChemicalReading extends Equatable {
  @HiveField(0)
  final WaterBodyType waterBody;
  @HiveField(1)
  final double? chlorine;
  @HiveField(2)
  final double? ph;
  @HiveField(3)
  final double? hardness;
  @HiveField(4)
  final double? alkalinity;
  @HiveField(5)
  final double? cyanuricAcid;
  @HiveField(6)
  final double? temperature;
  @HiveField(7)
  final String? notes;

  const ChemicalReading({
    required this.waterBody,
    this.chlorine,
    this.ph,
    this.hardness,
    this.alkalinity,
    this.cyanuricAcid,
    this.temperature,
    this.notes,
  });

  ChemicalReading copyWith({
    WaterBodyType? waterBody,
    double? chlorine,
    double? ph,
    double? hardness,
    double? alkalinity,
    double? cyanuricAcid,
    double? temperature,
    String? notes,
  }) {
    return ChemicalReading(
      waterBody: waterBody ?? this.waterBody,
      chlorine: chlorine ?? this.chlorine,
      ph: ph ?? this.ph,
      hardness: hardness ?? this.hardness,
      alkalinity: alkalinity ?? this.alkalinity,
      cyanuricAcid: cyanuricAcid ?? this.cyanuricAcid,
      temperature: temperature ?? this.temperature,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waterBody': waterBody.name,
      'chlorine': chlorine,
      'ph': ph,
      'hardness': hardness,
      'alkalinity': alkalinity,
      'cyanuricAcid': cyanuricAcid,
      'temperature': temperature,
      'notes': notes,
    };
  }

  factory ChemicalReading.fromJson(Map<String, dynamic> json) {
    return ChemicalReading(
      waterBody: WaterBodyType.values.firstWhere(
        (e) => e.name == json['waterBody'],
        orElse: () => WaterBodyType.mainPool,
      ),
      chlorine: json['chlorine'] as double?,
      ph: json['ph'] as double?,
      hardness: json['hardness'] as double?,
      alkalinity: json['alkalinity'] as double?,
      cyanuricAcid: json['cyanuricAcid'] as double?,
      temperature: json['temperature'] as double?,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        waterBody,
        chlorine,
        ph,
        hardness,
        alkalinity,
        cyanuricAcid,
        temperature,
        notes,
      ];
}

/// Photo with geolocation and timestamp
@HiveType(typeId: 3)
class ChecklistPhoto extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final PhotoType type;
  @HiveField(2)
  final String localPath;
  @HiveField(3)
  final String? serverUrl;
  @HiveField(4)
  final double latitude;
  @HiveField(5)
  final double longitude;
  @HiveField(6)
  final DateTime timestamp;
  @HiveField(7)
  final bool uploaded;

  const ChecklistPhoto({
    required this.id,
    required this.type,
    required this.localPath,
    this.serverUrl,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.uploaded = false,
  });

  ChecklistPhoto copyWith({
    String? id,
    PhotoType? type,
    String? localPath,
    String? serverUrl,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    bool? uploaded,
  }) {
    return ChecklistPhoto(
      id: id ?? this.id,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      serverUrl: serverUrl ?? this.serverUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'localPath': localPath,
      'serverUrl': serverUrl,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'uploaded': uploaded,
    };
  }

  factory ChecklistPhoto.fromJson(Map<String, dynamic> json) {
    return ChecklistPhoto(
      id: json['id'] as String,
      type: PhotoType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PhotoType.mainPoolFullView,
      ),
      localPath: json['localPath'] as String,
      serverUrl: json['serverUrl'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      uploaded: json['uploaded'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        localPath,
        serverUrl,
        latitude,
        longitude,
        timestamp,
        uploaded,
      ];
}

/// Complete Service Technician Checklist
@HiveType(typeId: 4)
class ServiceChecklist extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int locationId;
  @HiveField(2)
  final int userId;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final List<ServiceChecklistItem> items;
  @HiveField(5)
  final List<ChemicalReading> chemicalReadings;
  @HiveField(6)
  final List<String> suppliesNeeded;
  @HiveField(7)
  final List<ChecklistPhoto> photos;
  @HiveField(8)
  final bool poolGateLocked;
  @HiveField(9)
  final String? notes;
  @HiveField(10)
  final bool submitted;
  @HiveField(11)
  final DateTime? submittedAt;
  @HiveField(12)
  final bool synced;

  const ServiceChecklist({
    required this.id,
    required this.locationId,
    required this.userId,
    required this.date,
    required this.items,
    this.chemicalReadings = const [],
    this.suppliesNeeded = const [],
    this.photos = const [],
    this.poolGateLocked = false,
    this.notes,
    this.submitted = false,
    this.submittedAt,
    this.synced = false,
  });

  bool get isComplete {
    return items.every((item) => item.isCompleted) &&
        chemicalReadings.isNotEmpty &&
        photos.length == 5 &&
        poolGateLocked;
  }

  int get completionPercentage {
    int total = items.length + 1 + 5 + 1; // items + chemicals + photos + gate
    int completed = items.where((i) => i.isCompleted).length +
        (chemicalReadings.isNotEmpty ? 1 : 0) +
        photos.length +
        (poolGateLocked ? 1 : 0);
    return ((completed / total) * 100).round();
  }

  ServiceChecklist copyWith({
    String? id,
    int? locationId,
    int? userId,
    DateTime? date,
    List<ServiceChecklistItem>? items,
    List<ChemicalReading>? chemicalReadings,
    List<String>? suppliesNeeded,
    List<ChecklistPhoto>? photos,
    bool? poolGateLocked,
    String? notes,
    bool? submitted,
    DateTime? submittedAt,
    bool? synced,
  }) {
    return ServiceChecklist(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      items: items ?? this.items,
      chemicalReadings: chemicalReadings ?? this.chemicalReadings,
      suppliesNeeded: suppliesNeeded ?? this.suppliesNeeded,
      photos: photos ?? this.photos,
      poolGateLocked: poolGateLocked ?? this.poolGateLocked,
      notes: notes ?? this.notes,
      submitted: submitted ?? this.submitted,
      submittedAt: submittedAt ?? this.submittedAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'userId': userId,
      'date': date.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'chemicalReadings': chemicalReadings.map((c) => c.toJson()).toList(),
      'suppliesNeeded': suppliesNeeded,
      'photos': photos.map((p) => p.toJson()).toList(),
      'poolGateLocked': poolGateLocked,
      'notes': notes,
      'submitted': submitted,
      'submittedAt': submittedAt?.toIso8601String(),
      'synced': synced,
    };
  }

  factory ServiceChecklist.fromJson(Map<String, dynamic> json) {
    return ServiceChecklist(
      id: json['id'] as String,
      locationId: json['locationId'] as int,
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List)
          .map((i) => ServiceChecklistItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      chemicalReadings: (json['chemicalReadings'] as List?)
              ?.map((c) => ChemicalReading.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      suppliesNeeded: (json['suppliesNeeded'] as List?)?.cast<String>() ?? [],
      photos: (json['photos'] as List?)
              ?.map((p) => ChecklistPhoto.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      poolGateLocked: json['poolGateLocked'] as bool? ?? false,
      notes: json['notes'] as String?,
      submitted: json['submitted'] as bool? ?? false,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      synced: json['synced'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        locationId,
        userId,
        date,
        items,
        chemicalReadings,
        suppliesNeeded,
        photos,
        poolGateLocked,
        notes,
        submitted,
        submittedAt,
        synced,
      ];
}

/// Default Service Checklist Items
class DefaultServiceChecklistItems {
  static List<ServiceChecklistItem> get items => [
        const ServiceChecklistItem(
          id: '1',
          description: 'Pool Vacuumed',
        ),
        const ServiceChecklistItem(
          id: '2',
          description: 'Pool Brushed',
        ),
        const ServiceChecklistItem(
          id: '3',
          description: 'Skimmers Empty',
        ),
        const ServiceChecklistItem(
          id: '4',
          description: 'Pump Baskets Empty',
        ),
        const ServiceChecklistItem(
          id: '5',
          description: 'Backwash Filter (if needed)',
        ),
        const ServiceChecklistItem(
          id: '6',
          description: 'Test Water Chemistry',
        ),
        const ServiceChecklistItem(
          id: '7',
          description: 'Adjust Chemicals',
        ),
        const ServiceChecklistItem(
          id: '8',
          description: 'Clean Deck Area',
        ),
        const ServiceChecklistItem(
          id: '9',
          description: 'Empty Trash Receptacles',
        ),
        const ServiceChecklistItem(
          id: '10',
          description: 'Inspect Equipment Room',
        ),
        const ServiceChecklistItem(
          id: '11',
          description: 'Check Flowrate',
        ),
        const ServiceChecklistItem(
          id: '12',
          description: 'Calibrate Chemical Controller',
        ),
      ];
}

/// Supply items that can be ordered
class SupplyItems {
  static const List<String> items = [
    'Order Chlorine',
    'Order pH Adjusters (Up/Down)',
    'Order Alkalinity Increaser',
    'Order Calcium Hardness Increaser',
    'Order Cyanuric Acid',
    'Order Filter Cartridges',
    'Order DE Powder',
    'Order Test Strips/Reagents',
  ];
}
