import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:restart_app/restart_app.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  init() async {
    await getUserData();
    await getSalonOrExpert();
  }

//! Salon Or Expert
  bool isSalon = false;
  bool isExpert = false;

  setSalonOrExpert(String value) async {
    // إعادة تعيين الحالات
    isSalon = false;
    isExpert = false;

    // تخزين القيمة الجديدة في التخزين المؤقت
    await sl<CacheHelper>().setData(AppConstants.salonOrExpert, value);

    // تعيين الحالة بناءً على القيمة
    value == AppConstants.salon ? (isSalon = true) : (isExpert = true);

    // إطلاق الحالة الجديدة
    emit(ChooseSalonOrExpertState());
  }

  getSalonOrExpert() {
    try {
      // جلب القيمة المخزنة
      final storedValue = sl<CacheHelper>().getUserOrVendor();

      if (storedValue == AppConstants.salon) {
        isSalon = true;
        isExpert = false;
      } else if (storedValue == AppConstants.expert) {
        isExpert = true;
        isSalon = false;
      } else {
        emit(const ErrorState("No valid value found for Salon or Expert"));
      }
    } catch (e) {
      emit(const ErrorState("Failed to get Salon or Expert"));
    }
  }

  String language = sl<CacheHelper>().getCachedLanguage();
  changeLanguage() {
    sl<CacheHelper>().getCachedLanguage() == "en"
        ? sl<CacheHelper>().cacheLanguage("ar")
        : sl<CacheHelper>().cacheLanguage("en");
    language = sl<CacheHelper>().getCachedLanguage();
    emit(LanguageChangeState());
    Restart.restartApp();
  }

  //! User Data
  int? userId;
  String? userName, userEmail, userPhone, userImageUrl;
  getUserData() async {
    if (sl<CacheHelper>().getData(key: AppConstants.token) != null) {
      Map<String, dynamic> userJson =
          jsonDecode(sl<CacheHelper>().getData(key: AppConstants.user));
      UserModel model = UserModel.fromJson(userJson);
      userId = model.id;
      userName = model.name;
      userEmail = model.email;
      userPhone = model.phone;
      userImageUrl = model.image;
      emit(GetUserDataState());
    }
  }
}
