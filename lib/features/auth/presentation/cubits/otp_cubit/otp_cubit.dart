import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/constants/AppConstants.dart';
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
  Future<void> expertLoginVerifyOtp() async {
    emit(CheckOtpLoadingState());
    final result = await sl<AuthRepo>().expertLoginVerifyOtp(
      phone: phone!,
      otp: otpController.text,
    );
    result.fold(
      (l) => emit(CheckOtpErrorState(message: l)),
      (r) {
        sl<CacheHelper>().saveData(
          key: AppConstants.token,
          value: r.token,
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
  Future<void> expertResendCode() async {
    emit(ResendCodeLoadingState());
    final result = await sl<AuthRepo>().expertLogin(phone: phone!);
    result.fold(
      (l) => emit(ResendCodeErrorState(message: l)),
      (r) => emit(ResendCodeSuccessState(message: r)),
    );
  }
}
