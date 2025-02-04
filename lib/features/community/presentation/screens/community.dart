import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/community/presentation/cubit/community_cubit.dart';
import 'package:maxless/features/community/presentation/widgets/community_body.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityCubit()..init(),
      child: BlocConsumer<CommunityCubit, CommunityState>(
        listener: (context, state) {
          if (state is GetCommunityErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                SizedBox(height: 20.h),
                CustomHeader(
                  title: "community".tr(context),
                  onBackPress: () {
                    Navigator.pop(context);
                  },
                ),
                state is GetCommunityLoadingState
                    ? const Expanded(child: CustomLoadingIndicator())
                    : const CommunityBody(),
              ],
            ),
          );
        },
      ),
    );
  }
}
