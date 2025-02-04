import 'package:maxless/core/database/api/end_points.dart';

class ResponseModel {
  final bool? result;
  final String? message;
  final dynamic data;

  ResponseModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> map) {
    return ResponseModel(
      result: map[ApiKey.result],
      message: map[ApiKey.message],
      data: map[ApiKey.data],
    );
  }
}
