import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'safety_audit_model.g.dart';

/// Safety Audit Checklist Item
@HiveType(typeId: 5)
class SafetyChecklistItem extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool isCompliant;
  @HiveField(4)
  final String? notes;
  @HiveField(5)
  final bool isRequired;

  const SafetyChecklistItem({
    required this.id,
    required this.category,
    required this.description,
    this.isCompliant = false,
    this.notes,
    this.isRequired = true,
  });

  SafetyChecklistItem copyWith({
    String? id,
    String? category,
    String? description,
    bool? isCompliant,
    String? notes,
    bool? isRequired,
  }) {
    return SafetyChecklistItem(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      isCompliant: isCompliant ?? this.isCompliant,
      notes: notes ?? this.notes,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'isCompliant': isCompliant,
      'notes': notes,
      'isRequired': isRequired,
    };
  }

  factory SafetyChecklistItem.fromJson(Map<String, dynamic> json) {
    return SafetyChecklistItem(
      id: json['id'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      isCompliant: json['isCompliant'] as bool? ?? false,
      notes: json['notes'] as String?,
      isRequired: json['isRequired'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
        id,
        category,
        description,
        isCompliant,
        notes,
        isRequired,
      ];
}

/// Staff discussion confirmation
@HiveType(typeId: 6)
class StaffDiscussion extends Equatable {
  @HiveField(0)
  final String topic;
  @HiveField(1)
  final bool confirmed;
  @HiveField(2)
  final String? notes;

  const StaffDiscussion({
    required this.topic,
    this.confirmed = false,
    this.notes,
  });

  StaffDiscussion copyWith({
    String? topic,
    bool? confirmed,
    String? notes,
  }) {
    return StaffDiscussion(
      topic: topic ?? this.topic,
      confirmed: confirmed ?? this.confirmed,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'confirmed': confirmed,
      'notes': notes,
    };
  }

  factory StaffDiscussion.fromJson(Map<String, dynamic> json) {
    return StaffDiscussion(
      topic: json['topic'] as String,
      confirmed: json['confirmed'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [topic, confirmed, notes];
}

/// Complete Safety Audit
@HiveType(typeId: 7)
class SafetyAudit extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int locationId;
  @HiveField(2)
  final int auditorId;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final List<SafetyChecklistItem> items;
  @HiveField(5)
  final List<StaffDiscussion> discussions;
  @HiveField(6)
  final List<String> staffOnDuty;
  @HiveField(7)
  final String? safetyConcerns;
  @HiveField(8)
  final bool submitted;
  @HiveField(9)
  final DateTime? submittedAt;
  @HiveField(10)
  final bool synced;

  const SafetyAudit({
    required this.id,
    required this.locationId,
    required this.auditorId,
    required this.date,
    required this.items,
    this.discussions = const [],
    this.staffOnDuty = const [],
    this.safetyConcerns,
    this.submitted = false,
    this.submittedAt,
    this.synced = false,
  });

  bool get isComplete {
    return items.where((i) => i.isRequired).every((i) => i.isCompliant) &&
        discussions.every((d) => d.confirmed);
  }

  int get completionPercentage {
    int totalRequired = items.where((i) => i.isRequired).length;
    int completedRequired =
        items.where((i) => i.isRequired && i.isCompliant).length;
    if (totalRequired == 0) return 0;
    return ((completedRequired / totalRequired) * 100).round();
  }

  int get nonCompliantCount {
    return items.where((i) => i.isRequired && !i.isCompliant).length;
  }

  SafetyAudit copyWith({
    String? id,
    int? locationId,
    int? auditorId,
    DateTime? date,
    List<SafetyChecklistItem>? items,
    List<StaffDiscussion>? discussions,
    List<String>? staffOnDuty,
    String? safetyConcerns,
    bool? submitted,
    DateTime? submittedAt,
    bool? synced,
  }) {
    return SafetyAudit(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      auditorId: auditorId ?? this.auditorId,
      date: date ?? this.date,
      items: items ?? this.items,
      discussions: discussions ?? this.discussions,
      staffOnDuty: staffOnDuty ?? this.staffOnDuty,
      safetyConcerns: safetyConcerns ?? this.safetyConcerns,
      submitted: submitted ?? this.submitted,
      submittedAt: submittedAt ?? this.submittedAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'auditorId': auditorId,
      'date': date.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'discussions': discussions.map((d) => d.toJson()).toList(),
      'staffOnDuty': staffOnDuty,
      'safetyConcerns': safetyConcerns,
      'submitted': submitted,
      'submittedAt': submittedAt?.toIso8601String(),
      'synced': synced,
    };
  }

  factory SafetyAudit.fromJson(Map<String, dynamic> json) {
    return SafetyAudit(
      id: json['id'] as String,
      locationId: json['locationId'] as int,
      auditorId: json['auditorId'] as int,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List)
          .map((i) => SafetyChecklistItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      discussions: (json['discussions'] as List?)
              ?.map((d) => StaffDiscussion.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      staffOnDuty: (json['staffOnDuty'] as List?)?.cast<String>() ?? [],
      safetyConcerns: json['safetyConcerns'] as String?,
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
        auditorId,
        date,
        items,
        discussions,
        staffOnDuty,
        safetyConcerns,
        submitted,
        submittedAt,
        synced,
      ];
}

/// Default Safety Audit Checklist Items
class DefaultSafetyChecklistItems {
  static List<SafetyChecklistItem> get items => [
        // Pool Status
        const SafetyChecklistItem(
          id: 's1',
          category: 'Pool Status',
          description: 'Pool Open?',
        ),
        const SafetyChecklistItem(
          id: 's2',
          category: 'Pool Status',
          description: 'Water Clear and Safe?',
        ),
        const SafetyChecklistItem(
          id: 's3',
          category: 'Pool Status',
          description: 'Proper Water Level?',
        ),

        // Safety Equipment
        const SafetyChecklistItem(
          id: 's4',
          category: 'Safety Equipment',
          description: 'AED Present and Accessible',
        ),
        const SafetyChecklistItem(
          id: 's5',
          category: 'Safety Equipment',
          description: 'Rescue Tube Available',
        ),
        const SafetyChecklistItem(
          id: 's6',
          category: 'Safety Equipment',
          description: 'First Aid Kit Stocked',
        ),
        const SafetyChecklistItem(
          id: 's7',
          category: 'Safety Equipment',
          description: 'Shepherd\'s Crook Available',
        ),
        const SafetyChecklistItem(
          id: 's8',
          category: 'Safety Equipment',
          description: 'Backboard Present',
        ),
        const SafetyChecklistItem(
          id: 's9',
          category: 'Safety Equipment',
          description: 'Ring Buoy Available',
        ),

        // Facility Safety
        const SafetyChecklistItem(
          id: 's10',
          category: 'Facility Safety',
          description: 'Gate Secured Properly',
        ),
        const SafetyChecklistItem(
          id: 's11',
          category: 'Facility Safety',
          description: 'Emergency Phone Working',
        ),
        const SafetyChecklistItem(
          id: 's12',
          category: 'Facility Safety',
          description: 'Emergency Numbers Posted',
        ),
        const SafetyChecklistItem(
          id: 's13',
          category: 'Facility Safety',
          description: 'Pool Rules Posted',
        ),
        const SafetyChecklistItem(
          id: 's14',
          category: 'Facility Safety',
          description: 'Depth Markers Visible',
        ),
        const SafetyChecklistItem(
          id: 's15',
          category: 'Facility Safety',
          description: 'No Slip Hazards on Deck',
        ),
        const SafetyChecklistItem(
          id: 's16',
          category: 'Facility Safety',
          description: 'Chemical Storage Secure',
        ),

        // Lifeguard Compliance
        const SafetyChecklistItem(
          id: 's17',
          category: 'Lifeguard Compliance',
          description: 'Lifeguard in Proper Position',
        ),
        const SafetyChecklistItem(
          id: 's18',
          category: 'Lifeguard Compliance',
          description: 'Lifeguard Attentive (No Phone)',
        ),
        const SafetyChecklistItem(
          id: 's19',
          category: 'Lifeguard Compliance',
          description: 'Whistle Present',
        ),
        const SafetyChecklistItem(
          id: 's20',
          category: 'Lifeguard Compliance',
          description: 'Rescue Equipment Nearby',
        ),
        const SafetyChecklistItem(
          id: 's21',
          category: 'Lifeguard Compliance',
          description: 'Current CPR/First Aid Certification',
        ),

        // Environmental
        const SafetyChecklistItem(
          id: 's22',
          category: 'Environmental',
          description: 'Weather Conditions Safe',
        ),
        const SafetyChecklistItem(
          id: 's23',
          category: 'Environmental',
          description: 'Adequate Lighting (if evening)',
        ),
      ];
}

/// Default Staff Discussions
class DefaultStaffDiscussions {
  static List<StaffDiscussion> get discussions => [
        const StaffDiscussion(topic: 'Scanning and Rotation Discussed'),
        const StaffDiscussion(topic: 'Break Time Policy Reviewed'),
        const StaffDiscussion(topic: 'Cellphone Policy Confirmed'),
        const StaffDiscussion(topic: 'Emergency Procedures Reviewed'),
      ];
}
