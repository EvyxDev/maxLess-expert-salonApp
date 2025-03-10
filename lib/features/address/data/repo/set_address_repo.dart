import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/community/data/models/expert_model.dart';

class SetAddressRepo {
  final DioConsumer api;

  SetAddressRepo(this.api);

  //! Set Salon Address
  Future<Either<String, ExpertModel>> setSalonAddress({
    required String lat,
    required String lon,
    required String address,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.setSalonAddress,
        isFormData: true,
        data: {
          ApiKey.lat: lat,
          ApiKey.lon: lon,
          ApiKey.address: address,
        },
      );
      return Right(ExpertModel.fromJson(response.data["salon"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
