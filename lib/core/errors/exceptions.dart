import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/splash.dart';

import '../app/maxliss.dart';
import '../cubit/global_cubit.dart';
import '../network/local_network.dart';
import '../services/service_locator.dart';
import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!No Internet
class NoInternetException implements Exception {
  final ErrorModel errorModel;
  NoInternetException(this.errorModel);
}

//!CacheExeption
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    //! Connection Error
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel(detail: e.error.toString()));
    //! Bad Certificate
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson(e.response!.data));
    //! Connection Timeout
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel(detail: e.error.toString()));
    //! Receive Timeout
    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data));
    //! Send Timeout
    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson(e.response!.data));
    //! Bad Response
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 302: // Bad request
          throw BadResponseException(ErrorModel(detail: e.message ?? "..."));

        case 400: // Bad request

          throw BadResponseException(ErrorModel.fromJson(e.response!.data));

        case 401: //unauthorized

          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data));

        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));

        case 404: //not found
          sl<CacheHelper>().removeKey(key: AppConstants.token);
          sl<CacheHelper>().removeKey(key: AppConstants.user);
          sl<CacheHelper>().removeKey(key: AppConstants.wssToken);
          sl<CacheHelper>().removeKey(key: AppConstants.cookie);
          sl<GlobalCubit>().isExpert = true;
          sl<GlobalCubit>().isSalon = false;
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return const SplashScreen();
            }),
            (route) => false,
          );
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));

        case 409: //cofficient

          throw CofficientException(ErrorModel.fromJson(e.response!.data));

        case 413:
          throw BadResponseException(ErrorModel(detail: e.response!.data));

        case 422: //  Unprocessable Entity
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));
        case 504: // Bad request
          throw BadResponseException(ErrorModel(
            detail: e.response!.data,
          ));
        case 500:
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));
      }
    //! Cancel
    case DioExceptionType.cancel:
      throw CancelException(ErrorModel(detail: e.toString()));
    //! Unknown
    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel(detail: e.toString()));
  }
}
