import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../cubit/schedule_cubit.dart';

class SchduleDaysGridView extends StatelessWidget {
  const SchduleDaysGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleCubit>();
        return SizedBox(
          width: double.infinity,
          height: 285.h,
          child: GridView.builder(
            controller: cubit.daysScrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 14.w,
              mainAxisExtent: 60.h,
            ),
            itemCount:
                cubit.getDaysInMonth(DateTime.now().year, cubit.currentMonth),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  cubit.selectDay(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 2,
                      color: cubit.isDayselected(index)
                          ? AppColors.primaryColor
                          : cubit.isDayAvilable(index)
                              ? AppColors.pink
                              : AppColors.grey,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //! Day Number
                            SizedBox(
                              height: 24.h,
                              child: FittedBox(
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                            //! Day Name
                            SizedBox(
                              height: 24.h,
                              child: FittedBox(
                                child: Text(
                                  cubit.getDayAbbreviation(
                                    date: DateTime(DateTime.now().year,
                                        cubit.currentMonth, index + 1),
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!cubit.isDayAvilable(index))
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Icon(
                            Icons.lock,
                            size: 12.w,
                            color: AppColors.lightGrey,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
