import 'package:maxless/core/database/api/end_points.dart';

import 'day_model.dart';

class SlotModel {
  final int? id;
  final String? start, end;
  final DayModel? day;

  SlotModel({
    required this.id,
    required this.start,
    required this.end,
    required this.day,
  });

  factory SlotModel.fromJson(Map<String, dynamic> map) {
    return SlotModel(
      id: map[ApiKey.id],
      start: map[ApiKey.start],
      end: map[ApiKey.end],
      day: map[ApiKey.day] != null ? DayModel.fromJson(map[ApiKey.day]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.start: start,
      ApiKey.end: end,
      ApiKey.day: day?.toJson(),
    };
  }
}
