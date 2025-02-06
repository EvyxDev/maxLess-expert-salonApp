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
}
