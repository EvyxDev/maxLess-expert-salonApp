import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/api_consumer.dart';
import 'package:maxless/features/schedule/data/models/unavilable_day.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';

class ScheduleRepo {
  final ApiConsumer api;

  ScheduleRepo(this.api);

  //! Get Un AvilableDays
  Future<Either<String, List<UnavilableDay>>> getUnAvilableDays() async {
    try {
      final Response response = await api.post(
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
}
