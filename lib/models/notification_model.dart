import 'package:equatable/equatable.dart';

/// Push Notification model
class PushNotification extends Equatable {
  final int id;
  final String title;
  final String message;
  final String targetUsers;
  final int? sentBy;
  final DateTime sentAt;
  final bool isSent;

  // Additional fields for display
  final String? senderName;

  const PushNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.targetUsers,
    this.sentBy,
    required this.sentAt,
    required this.isSent,
    this.senderName,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      targetUsers: json['targetUsers'] as String? ?? 'All',
      sentBy: json['sentBy'] as int?,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isSent: json['isSent'] as bool? ?? false,
      senderName: json['senderName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'targetUsers': targetUsers,
      'sentBy': sentBy,
      'sentAt': sentAt.toIso8601String(),
      'isSent': isSent,
      'senderName': senderName,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        targetUsers,
        sentBy,
        sentAt,
        isSent,
        senderName,
      ];
}

/// User Notification model
class UserNotification extends Equatable {
  final int id;
  final int userId;
  final int notificationId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  // Notification details
  final String? title;
  final String? message;
  final DateTime? sentAt;

  const UserNotification({
    required this.id,
    required this.userId,
    required this.notificationId,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.title,
    this.message,
    this.sentAt,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] as int,
      userId: json['userId'] as int,
      notificationId: json['notificationId'] as int,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'notificationId': notificationId,
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'message': message,
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        notificationId,
        isRead,
        readAt,
        createdAt,
        title,
        message,
        sentAt,
      ];
}

/// Notification Response
class NotificationResponse {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime sentAt;

  const NotificationResponse({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.sentAt,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}

/// Admin Notification Request
class AdminNotificationRequest {
  final String title;
  final String message;
  final String targetUsers;

  const AdminNotificationRequest({
    required this.title,
    required this.message,
    required this.targetUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'targetUsers': targetUsers,
    };
  }
}
