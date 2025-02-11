import 'package:maxless/core/database/api/end_points.dart';

import 'expert_model.dart';

class CommunityItemModel {
  int? id, likes;
  bool? isWishlist;
  ExpertModel? expert;
  String? title, time;
  List<String> images;

  CommunityItemModel({
    required this.id,
    required this.likes,
    required this.expert,
    required this.title,
    required this.images,
    required this.time,
    required this.isWishlist,
  });

  factory CommunityItemModel.fromJson(Map<String, dynamic> map) {
    return CommunityItemModel(
      id: map[ApiKey.id],
      likes: map[ApiKey.likes] is int
          ? map[ApiKey.likes]
          : map[ApiKey.likes] is String
              ? int.tryParse(map[ApiKey.likes])
              : 0,
      expert: ExpertModel.fromJson(map[ApiKey.expert]),
      title: map[ApiKey.title],
      images: map[ApiKey.images] != null
          ? (map[ApiKey.images] as List).map((e) => e.toString()).toList()
          : [],
      time: map[ApiKey.time],
      isWishlist: map[ApiKey.isWishlist],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.likes: ApiKey.likes,
      ApiKey.expert: expert?.toJson(),
      ApiKey.title: title,
      ApiKey.images: images.map((e) => e.toString()).toList(),
      ApiKey.time: time,
      ApiKey.isWishlist: isWishlist,
    };
  }
}
