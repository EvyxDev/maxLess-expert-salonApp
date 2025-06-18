import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/schedule/presentation/widgets/schesule_slider.dart';

import '../../../../core/component/custom_header.dart';
import '../cubit/schedule_cubit.dart';
import 'schedule_buttons.dart';
import 'schedule_days_grid_view.dart';
import 'schedule_from_to.dart';
import 'schedule_month_filter.dart';

class ScheduleBody extends StatelessWidget {
  const ScheduleBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(height: 20.h),
            //! Header
            CustomHeader(
              title: "schedule".tr(context),
              onBackPress: () {
                Navigator.pop(context);
              },
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Month Filter
                    const ScheduleMonthFilter(),

                    SizedBox(height: 16.h),

                    //! Days Gridview
                    const SchduleDaysGridView(),

                    SizedBox(height: 18.h),

                    //! Available Hours
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "available_hours".tr(context),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    //! From Slider
                    SchesuleSlider(
                      title: "from".tr(context),
                    ),
                    //! To Slider
                    SchesuleSlider(
                      title: "to".tr(context),
                    ),

                    SizedBox(height: 16.h),

                    //! From To
                    ...List.generate(2, (index) {
                      return ScheduleFromTo(
                        color: AppColors.primaryColor,
                        from: "1 ${"pm".tr(context)}",
                        to: "10 ${"pm".tr(context)}",
                      );
                    }),

                    SizedBox(height: 16.h),

                    //! Buttons
                    const ScheduleButtons(),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
