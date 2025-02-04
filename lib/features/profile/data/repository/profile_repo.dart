import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';
import 'package:maxless/features/profile/data/models/profile_model.dart';

class ProfileRepo {
  final DioConsumer api;

  ProfileRepo(this.api);

  //! Get Profile
  Future<Either<String, ProfileModel>> getExpertProfile() async {
    try {
      final Response response = await api.get(EndPoints.expertProfile);
      ResponseModel model = ResponseModel.fromJson(response.data);
      if (model.result == true) {
        return Right(ProfileModel.fromJson(model.data));
      } else {
        return Left(model.message ?? "...");
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
