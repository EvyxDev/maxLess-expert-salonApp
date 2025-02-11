import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';
import 'package:maxless/features/chatting/data/models/message_model.dart';

class ChattingRepo {
  final DioConsumer api;

  ChattingRepo(this.api);

  //! Get Expert Chat History
  Future<Either<String, List<MessageModel>>> getExpertChatHistory() async {
    try {
      final Response response = await api.get(EndPoints.getExpertChatHistory);
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right(
          (model.data as List).map((e) => MessageModel.fromJson(e)).toList());
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
