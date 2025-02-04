import 'package:maxless/core/database/api/end_points.dart';

class DayModel {
  final int? id;
  final String? name;

  DayModel({required this.id, required this.name});

  factory DayModel.fromJson(Map<String, dynamic> map) {
    return DayModel(
      id: map[ApiKey.id],
      name: map[ApiKey.name],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.name: name,
    };
  }
}
