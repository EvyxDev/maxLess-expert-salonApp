import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/component/custom_header.dart';
import '../cubit/schedule_cubit.dart';
import 'available_hours_section.dart';
import 'schedule_days_grid_view.dart';
import 'schedule_month_filter.dart';

class ScheduleBody extends StatelessWidget {
  const ScheduleBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleCubit, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleError) {
          showToast(context, message: state.error, state: ToastStates.success);
        } else if (state is ScheduleLoaded) {
          if (state.message != null) {
            showToast(context,
                message: state.message!, state: ToastStates.success);
          }
        }
      },
      builder: (context, state) {
        var cubit = context.read<ScheduleCubit>();
        return ModalProgressHUD(
          inAsyncCall: state is ScheduleLoading,
          progressIndicator: const CustomLoadingIndicator(),
          child: Column(
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
                      SizedBox(height: 16.h),

                      //! Available Hours
                      const AvailableHoursSection(),

                      const Spacer(),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomElevatedButton(
                          text: "save".tr(context),
                          borderColor: cubit.isAvailabilityChanged()
                              ? AppColors.primaryColor
                              : AppColors.lightGrey,
                          onPressed: cubit.isAvailabilityChanged()
                              ? () {
                                  cubit.putExceptions();
                                }
                              : null,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
