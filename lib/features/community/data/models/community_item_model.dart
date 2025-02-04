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
      likes: map[ApiKey.likes],
      expert: ExpertModel.fromJson(map[ApiKey.expert]),
      title: map[ApiKey.title],
      images: map[ApiKey.images] != null
          ? (map[ApiKey.images] as List).map((e) => e.toString()).toList()
          : [],
      time: map[ApiKey.time],
      isWishlist: map[ApiKey.isWishlist],
    );
  }
}
