import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/schedule/presentation/widgets/slot_item.dart';

import '../../../../core/constants/app_colors.dart';
import '../cubit/schedule_cubit.dart';
import 'active_day_switch.dart';

class AvailableHoursSection extends StatelessWidget {
  const AvailableHoursSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleCubit>();
        return Visibility(
          visible: cubit.availabilityByDateModel != null,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(
                      "available_hours".tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "day_on".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ActiveDaySwitch(
                      day: cubit.selectedDay ?? "",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250.h,
                      child: Visibility(
                        visible: cubit.fromSlots.isNotEmpty,
                        child: ListView.separated(
                          itemCount: cubit.fromSlots.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                if (index == 0)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        cubit.addNewSlot();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: AppColors.primaryColor,
                                            size: 18.sp,
                                          ),
                                          Text(
                                            "add_new".tr(context),
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                SlotItem(index: index),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
