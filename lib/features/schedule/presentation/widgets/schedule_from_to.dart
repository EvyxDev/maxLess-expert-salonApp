import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';

class ScheduleFromTo extends StatelessWidget {
  const ScheduleFromTo({
    super.key,
    required this.color,
    required this.from,
    required this.to,
  });

  final Color color;
  final String from, to;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
      ),
      child: Row(
        children: [
          //! Color
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 8.w),
          //! Text
          Text(
            "${"from".tr(context)} $from ${"to".tr(context)} $to",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Beiruti",
            ),
          ),
        ],
      ),
    );
  }
}
