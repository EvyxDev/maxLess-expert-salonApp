import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';

import 'slot_model.dart';

class UserModel {
  final int? id, experience, ratingCount;
  final double? rating;
  final String? wssToken,
      name,
      email,
      image,
      phone,
      city,
      state,
      lat,
      lon,
      price,
      address,
      createdAt,
      updatedAt;
  final List<SlotModel> slots;
  final List<CommunityItemModel> community;

  UserModel({
    required this.id,
    required this.rating,
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
    required this.city,
    required this.state,
    required this.lat,
    required this.lon,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.slots,
    required this.experience,
    required this.ratingCount,
    required this.community,
    required this.wssToken,
    required this.address
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map[ApiKey.id],
      wssToken: map[ApiKey.wssToken],
      rating: map[ApiKey.rating],
      name: map[ApiKey.name],
      email: map[ApiKey.email],
      image: map[ApiKey.image],
      phone: map[ApiKey.phone],
      city: map[ApiKey.city],
      state: map[ApiKey.state],
      lat: map[ApiKey.lat],
      lon: map[ApiKey.lon],
      price: map[ApiKey.price],
      createdAt: map[ApiKey.createdAt],
      updatedAt: map[ApiKey.updatedAt],
      experience: map[ApiKey.experience],
      ratingCount: map[ApiKey.ratingCount],
      address: map[ApiKey.address],
      slots: map[ApiKey.slots] != null
          ? (map[ApiKey.slots] as List)
              .map((e) => SlotModel.fromJson(e))
              .toList()
          : [],
      community: map[ApiKey.community] != null
          ? (map[ApiKey.community] as List)
              .map((e) => CommunityItemModel.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.wssToken: wssToken,
      ApiKey.rating: rating,
      ApiKey.name: name,
      ApiKey.email: email,
      ApiKey.image: image,
      ApiKey.phone: phone,
      ApiKey.city: city,
      ApiKey.state: state,
      ApiKey.lat: lat,
      ApiKey.lon: lon,
      ApiKey.price: price,
      ApiKey.createdAt: createdAt,
      ApiKey.updatedAt: updatedAt,
      ApiKey.address: address,
      ApiKey.experience: experience,
      ApiKey.slots: slots.map((e) => e.toJson()).toList(),
      ApiKey.community: community.map((e) => e.toJson()).toList(),
    };
  }
}
