import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatefulWidget {
  final String phone;

  const OtpVerification({super.key, required this.phone});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  List<TextEditingController> otpControllers = [];
  int remainingTime = 20; // الوقت المتبقي لإعادة الإرسال
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void resendCode() {
    setState(() {
      remainingTime = 20;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit()..phone = widget.phone,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is CheckOtpSuccessState) {
              navigateAndFinish(context, HomePage());
            }
            if (state is CheckOtpErrorState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
            }
            if (state is ResendCodeSuccessState) {
              setState(() {
                remainingTime = 20;
              });
              startTimer();
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
            }
            if (state is ResendCodeErrorState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<OtpCubit>();
            return CustomModalProgressIndicator(
              inAsyncCall: state is CheckOtpLoadingState ||
                      state is ResendCodeLoadingState
                  ? true
                  : false,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'check_email_title'.tr(context),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Description
                        Row(
                          children: [
                            Text(
                              "otp_verification_description".tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 10.h),
                            Text(
                              widget.phone,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),

                        // OTP Input Fields
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            length: 4,
                            controller: cubit.otpController,
                            defaultPinTheme: PinTheme(
                              width: 60.w,
                              height: 60.h,
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  // color: isOtpValid
                                  //     ? AppColors.grey
                                  //     : Colors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 75.w,
                              height: 60.h,
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors
                                      .primaryColor, // ✅ لون مميز عند التركيز
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            submittedPinTheme: PinTheme(
                              width: 60.w,
                              height: 60.h,
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (pin) {
                              if (pin == null || pin.length < 4) {
                                return AppStrings.otpRequired.tr(context);
                              }
                              return null;
                            },
                            onChanged: (pin) {
                              // setState(() {
                              //   otp = pin;
                              // });
                            },
                            onCompleted: (pin) {
                              // setState(() {
                              //   otp = pin;
                              // });
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // Verify Button
                        CustomElevatedButton(
                          text: 'verify_button'.tr(context),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (cubit.formKey.currentState!.validate()) {
                              context.read<GlobalCubit>().isExpert
                                  ? cubit.expertLoginVerifyOtp()
                                  : null;
                            }
                          },
                          color: AppColors.primaryColor,
                          borderRadius: 10.r,
                          icon: Icon(
                            CupertinoIcons.right_chevron,
                            color: Colors.white,
                            size: 15.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Resend Code Timer
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // النص الذي يظهر عند انتهاء العداد
                              if (remainingTime == 0)
                                GestureDetector(
                                  onTap: () {
                                    context.read<GlobalCubit>().isExpert
                                        ? cubit.expertResendCode()
                                        : null;
                                  },
                                  child: Text(
                                    'resend_code_ready'.tr(context),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),

                              // النص الذي يظهر أثناء العداد
                              if (remainingTime > 0)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'resend_code_timer'.tr(context),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      remainingTime.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      'seconds'.tr(context), // النص الثابت
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _buildOtpField(int index) {
  //   return SizedBox(
  //     width: 60.w,
  //     height: 60.h,
  //     child: TextField(
  //       controller: otpControllers[index],
  //       keyboardType: TextInputType.number,
  //       textAlign: TextAlign.center,
  //       maxLength: 1,
  //       style: TextStyle(
  //         fontSize: 24.sp,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       decoration: InputDecoration(
  //         counterText: '',
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12.r),
  //           borderSide: const BorderSide(
  //             color: Colors.black12,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12.r),
  //           borderSide: const BorderSide(
  //             color: AppColors.primaryColor,
  //           ),
  //         ),
  //       ),
  //       onChanged: (value) {
  //         if (value.isNotEmpty && index < otpControllers.length - 1) {
  //           FocusScope.of(context).nextFocus();
  //         } else if (value.isEmpty && index > 0) {
  //           FocusScope.of(context).previousFocus();
  //         }
  //       },
  //     ),
  //   );
  // }
}
