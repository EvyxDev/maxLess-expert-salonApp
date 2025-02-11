import 'package:maxless/core/database/api/end_points.dart';

class ExpertModel {
  final int? id;
  final String? name, email, location, image;

  ExpertModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.image,
  });

  factory ExpertModel.fromJson(Map<String, dynamic> map) {
    return ExpertModel(
      id: map[ApiKey.id],
      name: map[ApiKey.name],
      email: map[ApiKey.email],
      location: map[ApiKey.location],
      image: map[ApiKey.image],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.name: name,
      ApiKey.email: email,
      ApiKey.location: location,
      ApiKey.image: image,
    };
  }
}
