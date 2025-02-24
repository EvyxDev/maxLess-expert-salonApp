import 'package:maxless/core/database/api/end_points.dart';

class ReviewModel {
  final int? id, rate;
  final String? user, expertId, review, image, createdAt;

  ReviewModel({
    required this.id,
    required this.rate,
    required this.user,
    required this.expertId,
    required this.review,
    required this.image,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json[ApiKey.id],
      rate: json[ApiKey.rate],
      user: json[ApiKey.user],
      expertId: json[ApiKey.expertId],
      review: json[ApiKey.review],
      image: json[ApiKey.image],
      createdAt: json[ApiKey.createdAt],
    );
  }
}
