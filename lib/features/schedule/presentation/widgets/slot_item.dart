import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/widgets/custom_text_form_field.dart';
import '../cubit/schedule_cubit.dart';
import 'select_slot_time_bottom_sheet.dart';

class SlotItem extends StatelessWidget {
  const SlotItem({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleCubit>();
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.white,
                      builder: (context) {
                        return SelectSlotTimeBottomSheet(
                          initTime: cubit.fromSlots[index].text,
                        );
                      });
                  if (result != null) {
                    cubit.updateFromSlot(index, result);
                  }
                },
                child: CustomTextFormField(
                  borderRadius: 8.r,
                  borderColor: AppColors.grey,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  suffixIcon: const Icon(
                    Icons.access_time_filled_rounded,
                    color: AppColors.lightGrey,
                  ),
                  controller: cubit.fromSlots[index],
                  hintText: "from".tr(context),
                  enabled: false,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.white,
                      builder: (context) {
                        return SelectSlotTimeBottomSheet(
                          initTime: cubit.toSlots[index].text,
                        );
                      });
                  if (result != null) {
                    cubit.updateToSlot(index, result);
                  }
                },
                child: CustomTextFormField(
                  borderRadius: 8.r,
                  borderColor: AppColors.grey,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  suffixIcon: const Icon(
                    Icons.access_time_filled_rounded,
                    color: AppColors.lightGrey,
                  ),
                  hintText: "to".tr(context),
                  controller: cubit.toSlots[index],
                  enabled: false,
                ),
              ),
            ),
            if (cubit.fromSlots.length > 1)
              Row(
                children: [
                  SizedBox(width: 16.w),
                  InkWell(
                    onTap: () {
                      cubit.removeSlot(index);
                    },
                    child: const Icon(
                      Icons.delete_outlined,
                      color: AppColors.red2,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
