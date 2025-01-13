import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maxless/core/constants/AppConstants.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:restart_app/restart_app.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());
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
        emit(ErrorState("No valid value found for Salon or Expert"));
      }
    } catch (e) {
      emit(ErrorState("Failed to get Salon or Expert"));
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
}
