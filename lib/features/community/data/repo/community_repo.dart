import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';

import '../models/community_item_model.dart';
import '../models/community_model.dart';

class CommunityRepo {
  final DioConsumer api;

  CommunityRepo(this.api);

  //! Get Community
  Future<Either<String, CommunityModel>> expertCommunity({int? page}) async {
    try {
      final Response response = await api.get(
        EndPoints.expertCommunity,
        queryParameters: {
          "page": page,
        },
      );
      return Right(CommunityModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Community Details
  Future<Either<String, CommunityItemModel>> expertCommunityDetails(
      int id) async {
    try {
      final Response response = await api.get(
        EndPoints().experCommunityDetails(id),
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(CommunityItemModel.fromJson(model.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Create Community
  Future<Either<String, CommunityItemModel>> expertCreateCommunity({
    required String title,
    required List<MultipartFile> images,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.expertCreateCommunity,
        isFormData: true,
        data: {
          ApiKey.title: title,
          "images[]": images,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(CommunityItemModel.fromJson(model.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Update Community
  Future<Either<String, CommunityItemModel>> expertUpdateCommunity(
    int id, {
    String? title,
    List<MultipartFile>? images,
    List<String>? oldImages,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints().expertUpdateCommunity(id),
        isFormData: true,
        data: {
          ApiKey.title: title,
          "images[]": images,
          "old_images[]": oldImages,
          ApiKey.method: ApiKey.put,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(CommunityItemModel.fromJson(model.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Delete Community
  Future<Either<String, String>> expertDeleteCommunity(int id) async {
    try {
      final Response response = await api.delete(
        EndPoints().experDeleteCommunity(id),
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "...");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Like Community
  Future<Either<String, String>> expertLikeCommunity(int id) async {
    try {
      final Response response = await api.post(
        EndPoints.expertLikeCommunity,
        isFormData: true,
        data: {
          ApiKey.communityId: id,
        },
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "...");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
