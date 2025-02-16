import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';

class SessionRepo {
  final DioConsumer api;

  SessionRepo(this.api);

  //! Start Session
  Future<Either<String, String>> startSession({
    required int bookingId,
    required String userType,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "start_session",
          ApiKey.userType: userType,
          ApiKey.userId: userId,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! End Session
  Future<Either<String, String>> endSession({
    required int bookingId,
    required String userType,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "end_session",
          ApiKey.userType: userType,
          ApiKey.userId: userId,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Arrived Location
  Future<Either<String, String>> expertArrivedLocation({
    required int bookingId,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "arrived_location",
          ApiKey.userType: "expert",
          ApiKey.userId: userId,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Take a Photo
  Future<Either<String, String>> takePhoto({
    required int bookingId,
    required String userType,
    required int userId,
    required MultipartFile image,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "take_a_photo",
          ApiKey.userType: userType,
          ApiKey.userId: userId,
          ApiKey.image: image,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Expert Safe
  Future<Either<String, String>> expertSafe({
    required int bookingId,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "im_safe",
          ApiKey.userType: "expert",
          ApiKey.userId: userId,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Expert Session Feedback
  Future<Either<String, String>> expertSessionFeedback({
    required String review,
    required int expertId,
    required int userId,
    required int rating,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.expertSessionFeedback,
        isFormData: true,
        data: {
          ApiKey.review: review,
          ApiKey.expertId: expertId,
          ApiKey.userId: userId,
          ApiKey.rating: rating,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Session Last Step
  Future<Either<String, String?>> sessionLastStep({
    required int bookingId,
    required String userType,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.sessionLastStep,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.userType: userType,
          ApiKey.userId: userId,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(model.data?[ApiKey.status]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
