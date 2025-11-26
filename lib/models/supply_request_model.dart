import 'package:equatable/equatable.dart';

/// Supply Request model
class SupplyRequest extends Equatable {
  final int id;
  final int userId;
  final int locationId;
  final bool chlorine;
  final bool phAdjusters;
  final bool calciumHardener;
  final bool sodiumBicarb;
  final bool cyanuricAcid;
  final String? reagentsTaylorDrops;
  final String? additionalNotes;
  final String status;
  final DateTime requestedAt;
  final int? managedBy;
  final DateTime? managedAt;

  // Additional fields for display
  final String? locationName;
  final String? userName;
  final String? managerName;

  const SupplyRequest({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.chlorine,
    required this.phAdjusters,
    required this.calciumHardener,
    required this.sodiumBicarb,
    required this.cyanuricAcid,
    this.reagentsTaylorDrops,
    this.additionalNotes,
    required this.status,
    required this.requestedAt,
    this.managedBy,
    this.managedAt,
    this.locationName,
    this.userName,
    this.managerName,
  });

  factory SupplyRequest.fromJson(Map<String, dynamic> json) {
    return SupplyRequest(
      id: json['id'] as int,
      userId: json['userId'] as int,
      locationId: json['locationId'] as int,
      chlorine: json['chlorine'] as bool? ?? false,
      phAdjusters: json['phAdjusters'] as bool? ?? false,
      calciumHardener: json['calciumHardener'] as bool? ?? false,
      sodiumBicarb: json['sodiumBicarb'] as bool? ?? false,
      cyanuricAcid: json['cyanuricAcid'] as bool? ?? false,
      reagentsTaylorDrops: json['reagentsTaylorDrops'] as String?,
      additionalNotes: json['additionalNotes'] as String?,
      status: json['status'] as String? ?? 'Pending',
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      managedBy: json['managedBy'] as int?,
      managedAt: json['managedAt'] != null
          ? DateTime.parse(json['managedAt'] as String)
          : null,
      locationName: json['locationName'] as String?,
      userName: json['userName'] as String?,
      managerName: json['managerName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'locationId': locationId,
      'chlorine': chlorine,
      'phAdjusters': phAdjusters,
      'calciumHardener': calciumHardener,
      'sodiumBicarb': sodiumBicarb,
      'cyanuricAcid': cyanuricAcid,
      'reagentsTaylorDrops': reagentsTaylorDrops,
      'additionalNotes': additionalNotes,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
      'managedBy': managedBy,
      'managedAt': managedAt?.toIso8601String(),
      'locationName': locationName,
      'userName': userName,
      'managerName': managerName,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        locationId,
        chlorine,
        phAdjusters,
        calciumHardener,
        sodiumBicarb,
        cyanuricAcid,
        reagentsTaylorDrops,
        additionalNotes,
        status,
        requestedAt,
        managedBy,
        managedAt,
        locationName,
        userName,
        managerName,
      ];
}

/// Supply Request Submit Request
class SupplyRequestSubmit {
  final int locationId;
  final bool chlorine;
  final bool phAdjusters;
  final bool calciumHardener;
  final bool sodiumBicarb;
  final bool cyanuricAcid;
  final String? reagentsTaylorDrops;
  final String? additionalNotes;

  const SupplyRequestSubmit({
    required this.locationId,
    required this.chlorine,
    required this.phAdjusters,
    required this.calciumHardener,
    required this.sodiumBicarb,
    required this.cyanuricAcid,
    this.reagentsTaylorDrops,
    this.additionalNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'chlorine': chlorine,
      'phAdjusters': phAdjusters,
      'calciumHardener': calciumHardener,
      'sodiumBicarb': sodiumBicarb,
      'cyanuricAcid': cyanuricAcid,
      'reagentsTaylorDrops': reagentsTaylorDrops,
      'additionalNotes': additionalNotes,
    };
  }
}

/// Supply Request Response
class SupplyRequestResponse {
  final bool success;
  final String message;
  final int? requestId;
  final String? status;
  final DateTime? requestedAt;

  const SupplyRequestResponse({
    required this.success,
    required this.message,
    this.requestId,
    this.status,
    this.requestedAt,
  });

  factory SupplyRequestResponse.fromJson(Map<String, dynamic> json) {
    return SupplyRequestResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      requestId: json['requestId'] as int?,
      status: json['status'] as String?,
      requestedAt: json['requestedAt'] != null
          ? DateTime.parse(json['requestedAt'] as String)
          : null,
    );
  }
}
