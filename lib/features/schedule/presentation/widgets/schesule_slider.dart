import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';

class SchesuleSlider extends StatelessWidget {
  const SchesuleSlider({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! From
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 10.h,
            showValueIndicator: ShowValueIndicator.always,
            valueIndicatorColor: AppColors.white,
            valueIndicatorStrokeColor: AppColors.transparent,
            allowedInteraction: SliderInteraction.tapOnly,
          ),
          child: Slider(
            value: 12,
            min: 1,
            max: 24,
            onChanged: (value) {},
            activeColor: AppColors.primaryColor.withOpacity(.8),
            thumbColor: AppColors.primaryColor,
            inactiveColor: AppColors.pink,
            overlayColor: const WidgetStatePropertyAll(AppColors.transparent),
            label: "ss",
          ),
        ),
      ],
    );
  }
}
