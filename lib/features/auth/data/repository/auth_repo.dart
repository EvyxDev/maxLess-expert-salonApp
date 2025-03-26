import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/core/notifications/notification_handler.dart';
import 'package:maxless/features/auth/data/models/login_model.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';

class AuthRepo {
  final DioConsumer api;

  AuthRepo(this.api);

  //! Login
  Future<Either<String, String>> login({
    required String phone,
    required String type,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.expertLogin,
        isFormData: true,
        data: {
          ApiKey.phone: phone,
          ApiKey.type: type,
        },
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "...");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //! Verify Otp
  Future<Either<String, LoginModel>> loginVerifyOtp({
    required String phone,
    required String otp,
    required String type,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.expertLoginVerifyOtp,
        isFormData: true,
        data: {
          ApiKey.phone: phone,
          ApiKey.otp: otp,
          ApiKey.type: type,
          "fcm_token": NotificationHandler.fcmToken ?? "",
        },
      );
      return Right(LoginModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //! Logout
  Future<Either<String, String>> expertlogout() async {
    try {
      final Response response = await api.post(EndPoints.expertLogout);
      return Right(ResponseModel.fromJson(response.data).message ?? "...");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //! Set Location
  Future<Either<String, String>> expertSetLocation({
    required double lat,
    required double lon,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.expertSetLocation,
        isFormData: true,
        data: {
          ApiKey.lat: lat,
          ApiKey.lon: lon,
        },
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "...");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }
}
