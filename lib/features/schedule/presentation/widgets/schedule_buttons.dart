import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class ScheduleButtons extends StatelessWidget {
  const ScheduleButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          //! Add New Button
          CustomElevatedButton(
            text: "add_new".tr(context),
            onPressed: () {},
            color: AppColors.transparent,
            textColor: AppColors.primaryColor,
            icon: const Icon(
              Icons.add,
              color: AppColors.primaryColor,
            ),
          ),

          SizedBox(height: 16.h),

          //! Svae
          CustomElevatedButton(
            text: "save".tr(context),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
