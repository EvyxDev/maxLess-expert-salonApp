import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/community/data/models/pagination_model.dart';

import 'community_item_model.dart';

class CommunityModel {
  final String? message;
  final List<CommunityItemModel> data;
  final PaginationModel pagination;

  CommunityModel({
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> map) {
    return CommunityModel(
      message: map[ApiKey.message],
      data: map[ApiKey.data] != null
          ? (map[ApiKey.data] as List)
              .map((e) => CommunityItemModel.fromJson(e))
              .toList()
          : [],
      pagination: PaginationModel.fromJson(map["pagination"]),
    );
  }
}
