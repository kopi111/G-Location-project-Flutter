import 'package:equatable/equatable.dart';

/// Training Topic model
class TrainingTopic extends Equatable {
  final int id;
  final String topicName;
  final String topicCode;
  final String description;
  final int durationMinutes;
  final bool isActive;
  final DateTime createdAt;

  const TrainingTopic({
    required this.id,
    required this.topicName,
    required this.topicCode,
    required this.description,
    required this.durationMinutes,
    required this.isActive,
    required this.createdAt,
  });

  factory TrainingTopic.fromJson(Map<String, dynamic> json) {
    return TrainingTopic(
      id: json['id'] as int,
      topicName: json['topicName'] as String,
      topicCode: json['topicCode'] as String,
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicName': topicName,
      'topicCode': topicCode,
      'description': description,
      'durationMinutes': durationMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        topicName,
        topicCode,
        description,
        durationMinutes,
        isActive,
        createdAt,
      ];
}

/// User Training Progress model
class UserTrainingProgress extends Equatable {
  final int id;
  final int userId;
  final int topicId;
  final bool completed;
  final DateTime? completedAt;
  final double? score;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for display
  final String? topicName;
  final String? userName;

  const UserTrainingProgress({
    required this.id,
    required this.userId,
    required this.topicId,
    required this.completed,
    this.completedAt,
    this.score,
    required this.createdAt,
    required this.updatedAt,
    this.topicName,
    this.userName,
  });

  factory UserTrainingProgress.fromJson(Map<String, dynamic> json) {
    return UserTrainingProgress(
      id: json['id'] as int,
      userId: json['userId'] as int,
      topicId: json['topicId'] as int,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      topicName: json['topicName'] as String?,
      userName: json['userName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'topicId': topicId,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'topicName': topicName,
      'userName': userName,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        topicId,
        completed,
        completedAt,
        score,
        createdAt,
        updatedAt,
        topicName,
        userName,
      ];
}

/// Training Topic Response
class TrainingTopicResponse {
  final int id;
  final String topicName;
  final String topicCode;
  final String description;
  final int durationMinutes;

  const TrainingTopicResponse({
    required this.id,
    required this.topicName,
    required this.topicCode,
    required this.description,
    required this.durationMinutes,
  });

  factory TrainingTopicResponse.fromJson(Map<String, dynamic> json) {
    return TrainingTopicResponse(
      id: json['id'] as int,
      topicName: json['topicName'] as String,
      topicCode: json['topicCode'] as String,
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicName': topicName,
      'topicCode': topicCode,
      'description': description,
      'durationMinutes': durationMinutes,
    };
  }
}

/// Training Progress Response
class TrainingProgressResponse {
  final int id;
  final String topicName;
  final bool completed;
  final DateTime? completedAt;
  final double? score;

  const TrainingProgressResponse({
    required this.id,
    required this.topicName,
    required this.completed,
    this.completedAt,
    this.score,
  });

  factory TrainingProgressResponse.fromJson(Map<String, dynamic> json) {
    return TrainingProgressResponse(
      id: json['id'] as int,
      topicName: json['topicName'] as String,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicName': topicName,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'score': score,
    };
  }
}

/// Complete Training Request
class CompleteTrainingRequest {
  final int topicId;
  final double? score;

  const CompleteTrainingRequest({
    required this.topicId,
    this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'score': score,
    };
  }
}
