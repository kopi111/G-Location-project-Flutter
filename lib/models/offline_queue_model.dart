import 'package:equatable/equatable.dart';

/// Offline Queue model for syncing offline actions
class OfflineQueue extends Equatable {
  final int id;
  final int userId;
  final String actionType;
  final String payload;
  final bool isSynced;
  final int syncAttempts;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const OfflineQueue({
    required this.id,
    required this.userId,
    required this.actionType,
    required this.payload,
    required this.isSynced,
    required this.syncAttempts,
    required this.createdAt,
    this.syncedAt,
  });

  factory OfflineQueue.fromJson(Map<String, dynamic> json) {
    return OfflineQueue(
      id: json['id'] as int,
      userId: json['userId'] as int,
      actionType: json['actionType'] as String,
      payload: json['payload'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
      syncAttempts: json['syncAttempts'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'actionType': actionType,
      'payload': payload,
      'isSynced': isSynced,
      'syncAttempts': syncAttempts,
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        actionType,
        payload,
        isSynced,
        syncAttempts,
        createdAt,
        syncedAt,
      ];
}

/// Offline Action Request
class OfflineActionRequest {
  final String actionType;
  final String payload;

  const OfflineActionRequest({
    required this.actionType,
    required this.payload,
  });

  Map<String, dynamic> toJson() {
    return {
      'actionType': actionType,
      'payload': payload,
    };
  }
}

/// Sync Result Response
class SyncResultResponse {
  final bool success;
  final String message;
  final int syncedItems;
  final int failedItems;
  final List<String> errors;

  const SyncResultResponse({
    required this.success,
    required this.message,
    required this.syncedItems,
    required this.failedItems,
    required this.errors,
  });

  factory SyncResultResponse.fromJson(Map<String, dynamic> json) {
    return SyncResultResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      syncedItems: json['syncedItems'] as int? ?? 0,
      failedItems: json['failedItems'] as int? ?? 0,
      errors: (json['errors'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'syncedItems': syncedItems,
      'failedItems': failedItems,
      'errors': errors,
    };
  }
}

/// Sync Status Response
class SyncStatusResponse {
  final int pendingItems;
  final bool isOnline;
  final DateTime lastSync;

  const SyncStatusResponse({
    required this.pendingItems,
    required this.isOnline,
    required this.lastSync,
  });

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) {
    return SyncStatusResponse(
      pendingItems: json['pendingItems'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSync: json['lastSync'] != null
          ? DateTime.parse(json['lastSync'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendingItems': pendingItems,
      'isOnline': isOnline,
      'lastSync': lastSync.toIso8601String(),
    };
  }
}
