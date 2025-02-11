import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/errors/exceptions.dart';
import 'package:maxless/features/auth/data/models/response_model.dart';

import '../models/notification_model.dart';

class NotificationsRepo {
  final DioConsumer api;

  NotificationsRepo(this.api);

  //! Get Notifications
  Future<Either<String, List<NotificationModel>>>
      getExpertNotifications() async {
    try {
      final Response response = await api.get(EndPoints.getExpertNotifications);
      ResponseModel model = ResponseModel.fromJson(response.data);
      return Right((model.data as List)
          .map((e) => NotificationModel.fromJson(e))
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
