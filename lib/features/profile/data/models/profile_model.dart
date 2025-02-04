import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';

class ProfileModel {
  final UserModel? expert;
  final List<CommunityItemModel> posts;

  ProfileModel({
    required this.expert,
    required this.posts,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> map) {
    return ProfileModel(
      expert: UserModel.fromJson(map[ApiKey.expert]),
      posts: map[ApiKey.posts] != null
          ? (map[ApiKey.posts] as List)
              .map((e) => CommunityItemModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
