import 'package:maxless/core/database/api/end_points.dart';

import 'community_item_model.dart';

class CommunityModel {
  final String? message;
  final List<CommunityItemModel> data;

  CommunityModel({
    required this.message,
    required this.data,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> map) {
    return CommunityModel(
      message: map[ApiKey.message],
      data: map[ApiKey.data] != null
          ? (map[ApiKey.data] as List)
              .map((e) => CommunityItemModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
