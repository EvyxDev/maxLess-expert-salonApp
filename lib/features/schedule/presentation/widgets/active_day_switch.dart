
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../cubit/schedule_cubit.dart';

class ActiveDaySwitch extends StatefulWidget {
  const ActiveDaySwitch({
    super.key,
    required this.day,
  });
  final String day;
  @override
  State<ActiveDaySwitch> createState() => _ActiveDaySwitchState();
}

class _ActiveDaySwitchState extends State<ActiveDaySwitch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleCubit>();
        return SizedBox(
          width: 36.w,
          height: 28.h,
          child: FittedBox(
            child: Switch.adaptive(
              value: cubit.dayIsActive ?? true,
              activeTrackColor: AppColors.primaryColor,
              inactiveTrackColor: const Color(0xffE9EDF5),
              inactiveThumbColor: AppColors.white,
              trackOutlineColor: WidgetStateProperty.all(
                (cubit.dayIsActive ?? true)
                    ? AppColors.primaryColor
                    : const Color(0xffE9EDF5),
              ),
              onChanged: (value) {
                if (value == true) {
                  cubit.markAvilableDay(widget.day);
                } else {
                  cubit.markUnAvilableDay(widget.day);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
