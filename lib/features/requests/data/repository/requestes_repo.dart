import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';

class RequestesRepo {
  final DioConsumer api;

  RequestesRepo(this.api);

  //! Get Requests
  Future<Either<String, List<BookingItemModel>>> getExpertRequests() async {
    try {
      final Response response = await api.get(EndPoints.getExpertRequests);
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right((model.data as List)
          .map((e) => BookingItemModel.fromJson(e))
          .toList());
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Change Booking Status
  Future<Either<String, String>> expertChangeBookingStatus({
    required int bookingId,
    required int status,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.changeBookingStatus,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: status,
          ApiKey.userType: ApiKey.expert,
          ApiKey.userId: userId,
        },
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> salonChangeBookingStatus({
    required int bookingId,
    required int status,
    required int userId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.changeBookingStatus,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: status,
          ApiKey.userType: ApiKey.salon,
          ApiKey.userId: userId,
        },
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Cancel Request Reason
  Future<Either<String, String>> expertCancelReason({
    required int bookingId,
    required int userId,
    required String reason,
    required bool isEmergncy,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "cancel_session",
          ApiKey.userType: "expert",
          ApiKey.userId: userId,
          ApiKey.reason: reason,
          ApiKey.isEmergncy: isEmergncy ? 1 : 0,
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

  Future<Either<String, String>> salonCancelReason({
    required int bookingId,
    required int userId,
    required String reason,
    required bool isEmergncy,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.bookingActivities,
        isFormData: true,
        data: {
          ApiKey.bookingId: bookingId,
          ApiKey.status: "cancel_session",
          ApiKey.userType: "salon",
          ApiKey.userId: userId,
          ApiKey.reason: reason,
          ApiKey.isEmergncy: isEmergncy ? 1 : 0,
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
}
