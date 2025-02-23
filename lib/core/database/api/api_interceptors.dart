import 'package:dio/dio.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String? token = sl<CacheHelper>().getDataString(key: ApiKey.token);
    options.headers["Authorization"] = token != null ? 'Bearer $token' : null;
    options.headers["App-Language"] = sl<CacheHelper>().getCachedLanguage();
    options.headers["Cookie"] =
        "maxliss_session=${sl<CacheHelper>().getDataString(key: AppConstants.cookie)}";

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.realUri.toString().contains(EndPoints.expertLoginVerifyOtp)) {
      RegExp regex = RegExp(r'maxliss_session=([^;]*)');
      Match? match =
          regex.firstMatch(response.headers["Set-Cookie"].toString());

      String? sessionValue = match?.group(1);
      sl<CacheHelper>().setData(AppConstants.cookie, sessionValue ?? "");
    }
    super.onResponse(response, handler);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   super.onError(err, handler);
  // }
}
