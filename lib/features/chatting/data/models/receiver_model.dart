import 'package:maxless/core/database/api/end_points.dart';

class ReceiverModel {
  final int? id;
  final String? name, avatar;

  ReceiverModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory ReceiverModel.fromJson(Map<String, dynamic> map) {
    return ReceiverModel(
      id: map[ApiKey.id],
      name: map[ApiKey.name],
      avatar: map[ApiKey.avatar],
    );
  }
}
