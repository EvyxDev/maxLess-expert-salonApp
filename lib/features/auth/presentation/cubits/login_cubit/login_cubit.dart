import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/repository/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  init(bool isExpert) {
    isExpert
        ? phoneController.text =
            sl<CacheHelper>().getDataString(key: AppConstants.expertPhone) ?? ""
        : phoneController.text =
            sl<CacheHelper>().getDataString(key: AppConstants.salonPhone) ?? "";
  }

  //! Form
  GlobalKey<FormState> expertFromKey = GlobalKey<FormState>();
  GlobalKey<FormState> salonFromKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  //! Login
  Future<void> expertLogin() async {
    emit(LoginLoadingState());
    final result = await sl<AuthRepo>().expertLogin(
      phone: phoneController.text,
    );
    result.fold(
      (l) => emit(LoginErrorState(message: l)),
      (r) => emit(LoginSuccessState(message: r)),
    );
  }
}
