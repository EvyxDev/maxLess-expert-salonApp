import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maxless/core/constants/app_colors.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.descreption,
  });

  final String title, descreption;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: const Color(0xff9C9C9C))),
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.white,
            child: SvgPicture.asset(
              "./lib/assets/icons/transfare.svg",
              width: 30.w,
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Transaction Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                descreption,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
