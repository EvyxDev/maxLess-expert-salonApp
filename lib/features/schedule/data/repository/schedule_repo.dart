import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/api_consumer.dart';
import 'package:maxless/features/schedule/data/models/unavilable_day.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/availability_by_date_model/availability_by_date_model.dart';

class ScheduleRepo {
  final ApiConsumer api;

  ScheduleRepo(this.api);

  //! Get Un AvilableDays
  Future<Either<String, List<UnavilableDay>>> getUnAvilableDays() async {
    try {
      final Response response = await api.get(
        EndPoints.unAvailableDays,
      );
      List<UnavilableDay> unAvailableDays = (response.data['data'] as List)
          .map((e) => UnavilableDay.fromJson(e))
          .toList();
      return Right(unAvailableDays);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //!Mark Un Avilable Day
  Future<Either<String, String>> markUnAvilableDay(
      {required String day}) async {
    try {
      final Response response = await api.post(
        EndPoints.markUnavailable,
        data: {
          "date": day,
        },
      );
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //!Mark Avilable Day
  Future<Either<String, String>> markAvilableDay({required String day}) async {
    try {
      final Response response = await api.post(
        EndPoints.markAvailable,
        data: {
          "date": day,
        },
      );
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //! Put Exceptions
  Future<Either<String, String>> putExceptions({
    required String day,
    required List<Map<String, String>> slots,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "date": day,
        "slots": slots,
      };
      Response response = await api.post(
        EndPoints.putExceptions,
        data: data,
      );
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }

  //!availabilityByDate
  Future<Either<String, AvailabilityByDateModel>> availabilityByDate(
      {required String day}) async {
    try {
      final Response response = await api.get(
        EndPoints.availabilityByDate(day),
      );
      AvailabilityByDateModel data = AvailabilityByDateModel.fromJson(
        response.data,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppConstants.errorMessage());
    }
  }
}
