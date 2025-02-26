import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/profile/data/models/profile_model.dart';

import '../models/review_model.dart';

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

  //! Show Profile Details
  Future<Either<String, UserModel>> showProfileDetails(
      {required int id}) async {
    try {
      final Response response =
          await api.get(EndPoints.showProfileDetails(id: id));
      ResponseModel model = ResponseModel.fromJson(response.data);
      if (model.result == true) {
        return Right(UserModel.fromJson(model.data));
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

  //! Get Reviews
  Future<Either<String, List<ReviewModel>>> getReviews(
      {required int id}) async {
    try {
      final Response response = await api.get(
        EndPoints.getReviews,
        isFormData: true,
        data: {ApiKey.expertId: id},
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(
          (model.data as List).map((e) => ReviewModel.fromJson(e)).toList());
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
