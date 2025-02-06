import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';
import 'package:maxless/features/wallet/data/models/wallet_model.dart';

class WalletRepo {
  final DioConsumer api;

  WalletRepo(this.api);

  //! Get Transactions
  Future<Either<String, WalletModel>> getExpertWallet(
      {required int expertId}) async {
    try {
      final Response response = await api.post(
        EndPoints.getExpertWallet,
        isFormData: true,
        data: {
          ApiKey.expertId: expertId,
        },
      );
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(WalletModel.fromJson(model.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
