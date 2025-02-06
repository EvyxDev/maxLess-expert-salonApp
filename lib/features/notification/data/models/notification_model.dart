import 'package:maxless/core/database/api/end_points.dart';

class NotificationModel {
  final int? id, isRead;
  final String? title, descreption, image, createdAt, updatedAt;

  NotificationModel({
    required this.id,
    required this.isRead,
    required this.title,
    required this.descreption,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      id: map[ApiKey.id],
      title: map[ApiKey.title],
      descreption: map[ApiKey.body],
      image: map[ApiKey.image],
      isRead: map[ApiKey.image],
      createdAt: map[ApiKey.createdAt],
      updatedAt: map[ApiKey.updatedAt],
    );
  }
}
