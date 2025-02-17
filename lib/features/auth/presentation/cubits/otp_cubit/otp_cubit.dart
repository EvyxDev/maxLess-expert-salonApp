import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/repository/auth_repo.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  //! Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? phone;
  TextEditingController otpController = TextEditingController();

  //! Login Check Otp
  Future<void> loginVerifyOtp({required bool isExpert}) async {
    emit(CheckOtpLoadingState());
    final result = await sl<AuthRepo>().loginVerifyOtp(
      phone: phone!,
      otp: otpController.text,
      type: isExpert ? ApiKey.expert : ApiKey.salon,
    );
    result.fold(
      (l) => emit(CheckOtpErrorState(message: l)),
      (r) {
        sl<CacheHelper>().saveData(
          key: AppConstants.token,
          value: r.token,
        );
        sl<CacheHelper>().saveData(
          key: AppConstants.wssToken,
          value: r.user.wssToken,
        );
        Map<String, dynamic> userJson = r.user.toJson();
        sl<CacheHelper>().saveData(
          key: AppConstants.user,
          value: jsonEncode(userJson),
        );
        emit(CheckOtpSuccessState());
      },
    );
  }

  //! Resend Code
  Future<void> resendCode({required bool isExpert}) async {
    emit(ResendCodeLoadingState());
    final result = await sl<AuthRepo>().login(
      phone: phone!,
      type: isExpert ? ApiKey.expert : ApiKey.salon,
    );
    result.fold(
      (l) => emit(ResendCodeErrorState(message: l)),
      (r) => emit(ResendCodeSuccessState(message: r)),
    );
  }
}
