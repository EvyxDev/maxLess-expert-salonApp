import 'package:maxless/core/database/api/end_points.dart';

import 'slot_model.dart';

class UserModel {
  final int? id;
  final double? rating;
  final String? name,
      email,
      image,
      phone,
      city,
      state,
      lat,
      lon,
      price,
      createdAt,
      updatedAt;
  final List<SlotModel>? slots;

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
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map[ApiKey.id],
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
      slots: map[ApiKey.slots] != null
          ? (map[ApiKey.slots] as List)
              .map((e) => SlotModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
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
      ApiKey.slots: slots != null
          ? (slots as List<SlotModel>).map((e) => e.toJson()).toList()
          : null,
    };
  }
}
