import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';

class HomeRepo {
  final DioConsumer api;

  HomeRepo(this.api);

  //! Get Booking By Day
  Future<Either<String, List<BookingItemModel>>> getExpertBookingsByDate(
      {required String date}) async {
    try {
      final Response response = await api.post(
        EndPoints.expertBookingByDate,
        isFormData: true,
        data: {ApiKey.date: date},
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right((model.data as List)
          .map((e) => BookingItemModel.fromJson(e))
          .toList());
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //! Freeze
  Future<Either<String, String>> freezeToggle({required int value}) async {
    try {
      final Response response = await api.post(
        EndPoints.freeze,
        isFormData: true,
        data: {
          "freeze": value,
        },
      );
      return Right(ResponseModel.fromJson(response.data).message ?? "");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }
}
