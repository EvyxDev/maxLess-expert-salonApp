import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';

class LoginModel {
  final bool result;
  final String token;
  final UserModel user;

  LoginModel({
    required this.result,
    required this.token,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> map) {
    return LoginModel(
      result: map[ApiKey.result],
      token: map[ApiKey.token],
      user: UserModel.fromJson(map[ApiKey.user]),
    );
  }
}
