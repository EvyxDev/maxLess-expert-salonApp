import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/schedule/presentation/cubit/schedule_cubit.dart';

import '../../../../core/constants/app_colors.dart';

class ScheduleMonthFilter extends StatelessWidget {
  const ScheduleMonthFilter({
    super.key,
  });

  static List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //! Backward
            GestureDetector(
              onTap: () => cubit.selectMonth(0),
              child: SizedBox(
                height: 24.h,
                width: 24.w,
                child: cubit.currentMonth == 1
                    ? Container()
                    : Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.grey,
                        size: 14.h,
                      ),
              ),
            ),
            //! Month
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                months[cubit.currentMonth - 1].tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            //! Forward
            GestureDetector(
              onTap: () => cubit.selectMonth(1),
              child: SizedBox(
                height: 24.h,
                width: 24.w,
                child: cubit.currentMonth == 12
                    ? Container()
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.grey,
                        size: 14.h,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
