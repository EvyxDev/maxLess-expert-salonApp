import 'package:maxless/core/database/api/end_points.dart';

class SenderModel {
  final int? id;
  final String? name, image;

  SenderModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SenderModel.fromJson(Map<String, dynamic> map) {
    return SenderModel(
      id: map[ApiKey.id],
      name: map[ApiKey.name],
      image: map[ApiKey.image],
    );
  }
}
