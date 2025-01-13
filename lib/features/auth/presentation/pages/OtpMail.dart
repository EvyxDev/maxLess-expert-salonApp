import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/auth/presentation/pages/get-location.dart';

class OtpVerification extends StatefulWidget {
  final String phone;

  OtpVerification({required this.phone});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  List<TextEditingController> otpControllers = [];
  int remainingTime = 20; // الوقت المتبقي لإعادة الإرسال
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // إنشاء 4 حقول إدخال
    otpControllers = List.generate(4, (index) => TextEditingController());
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
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    print("Resending OTP...");
  }

  void verifyOtp() {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length == 4) {
      print("Verifying OTP: $otp");
      // Add your verification logic here
    } else {
      print("Incomplete OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    "${widget.phone}",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => _buildOtpField(index),
                ),
              ),
              SizedBox(height: 30.h),

              // Verify Button
              CustomElevatedButton(
                text: 'verify_button'.tr(context),
                onPressed: () {
                  navigateTo(context, LocationAccessScreen());
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
                        onTap: resendCode,
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
                            '${remainingTime.toString().padLeft(2, '0')}',
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
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: TextField(
        controller: otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Colors.black12,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < otpControllers.length - 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
