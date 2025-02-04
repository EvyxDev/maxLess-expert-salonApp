import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/constants/AppConstants.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/presentation/pages/login.dart';
import 'package:maxless/features/base/intro/presentation/presentation/cubits/logout_cubit/logout_cubit.dart';

void logoutAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => BlocProvider(
      create: (context) => LogoutCubit(),
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          // if (state is LogoutSuccessState) {

          // }
          // if (state is LogoutErrorState) {
          //   showToast(
          //     context,
          //     message: state.message,
          //     state: ToastStates.error,
          //   );
          // }
        },
        builder: (context, state) {
          return AlertDialog(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            title: Text(
              "logout_confirmation_message".tr(context), // نص ديناميكي
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: state is LogoutLoadingState
                        ? const CustomLoadingIndicator()
                        : CustomElevatedButton(
                            text: "yes_button".tr(context),
                            color: Colors.white,
                            borderRadius: 10,
                            borderColor: AppColors.primaryColor,
                            textColor: AppColors.primaryColor,
                            onPressed: () {
                              sl<CacheHelper>()
                                  .removeKey(key: AppConstants.token);
                              sl<CacheHelper>()
                                  .removeKey(key: AppConstants.user);
                              navigateAndFinish(context, const Login());
                              // context.read<GlobalCubit>().isExpert
                              //     ? cubit.expertLogout()
                              //     : null;
                            },
                          ),
                  ),
                  SizedBox(width: 10.h), // مسافة بين الأزرار

                  Expanded(
                    child: CustomElevatedButton(
                      text: "no_button".tr(context),
                      borderRadius: 10,
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pop(context); // إغلاق المودال
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
