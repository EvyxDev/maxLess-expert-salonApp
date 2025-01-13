import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/constants/AppConstants.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/constants/widgets/custom_text_form_field.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/auth/presentation/pages/OtpMail.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int selectedValue = 1; // Remember me checkbox value
  bool _isPasswordVisible = false; // Password visibility toggle
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    // تنظيف TextEditingController لتجنب تسرب الذاكرة
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // عدد التابات (خبيرة وصالون)
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: true,
          left: true,
          right: true,
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار
                  SizedBox(height: 100.h),
                  Center(
                    child: SvgPicture.asset(
                      "./lib/assets/logo.svg",
                      width: 212.w,
                      height: 75.h,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // التابات (خبيرة أو صالون)
                  Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: TabBar(
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      dividerColor: Colors.transparent,
                      dividerHeight: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                      tabs: [
                        Tab(
                          child: Text(
                            "experts".tr(context),
                            style: TextStyle(
                              fontFamily:
                                  context.read<GlobalCubit>().language == "ar"
                                      ? 'Beiruti'
                                      : "Jost",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              // color: Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "salons".tr(context),
                            style: TextStyle(
                              fontFamily:
                                  context.read<GlobalCubit>().language == "ar"
                                      ? 'Beiruti'
                                      : "Jost", // اسم الخط الخاص بك
                              fontSize: 14.sp, // حجم النص
                              fontWeight: FontWeight.w700, // الوزن
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // محتوى التاب
                  SizedBox(
                    height: 500.h,
                    child: TabBarView(
                      children: [
                        _buildLoginForm(isExpert: true),
                        _buildLoginForm(isExpert: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm({required bool isExpert}) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // حقل رقم الهاتف
          CustomTextFormField(
            borderRadius: 12.r,
            labelText: 'phone_number_label'.tr(context),
            hintText: 'phone_number_hint'.tr(context),
            keyboardType: TextInputType.phone,
            controller: _phoneController,
          ),
          SizedBox(height: 20.h),

          // Remember Me Checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    child: Checkbox(
                      value: selectedValue == 1,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedValue = value == true ? 1 : 0;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      side: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2.0,
                      ),
                      checkColor: Colors.white,
                      activeColor: AppColors.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'remember_me'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),

          // زر تسجيل الدخول
          CustomElevatedButton(
            text: "login".tr(context),
            onPressed: () {
              // استخدام GlobalCubit لتعيين الفلو (خبيرة أو صالون)
              if (isExpert) {
                context
                    .read<GlobalCubit>()
                    .setSalonOrExpert(AppConstants.expert);
              } else {
                context
                    .read<GlobalCubit>()
                    .setSalonOrExpert(AppConstants.salon);
              }

              // الانتقال إلى الصفحة التالية
              navigateTo(
                context,
                OtpVerification(
                  phone: _phoneController.text,
                ),
              );
            },
            color: AppColors.primaryColor,
            borderRadius: 10.r,
            icon: Icon(
              CupertinoIcons.right_chevron,
              color: Colors.white,
              size: 15.sp,
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
