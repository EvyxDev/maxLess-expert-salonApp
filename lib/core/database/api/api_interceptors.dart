import 'package:dio/dio.dart';
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
        "maxliss_session=sA147Hnl5bxLSm3liJWpcaijIqbmSDw6hqgK1rR5";

    super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   super.onResponse(response, handler);
  // }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   super.onError(err, handler);
  // }
}
