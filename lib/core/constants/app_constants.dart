import 'package:maxless/core/network/local_network.dart';

import '../services/service_locator.dart';

class AppConstants {
  static const String salonOrExpert = "salonOrExpert";
  static const String salon = "salon";
  static const String expert = "expert";
  static const String token = "token";
  static const String user = "user";
  static const String wssToken = "wssToken";
  static const String expertPhone = "expertPhone";
  static const String salonPhone = "salonPhone";
  static const String cookie = "cookie";
  static const String fcmToken = "fcmToken";

  static String errorMessage() {
    if (sl<CacheHelper>().getCachedLanguage() == "en") {
      return "An Error Occurred";
    } else {
      return "حدث خطأ";
    }
  }
}
