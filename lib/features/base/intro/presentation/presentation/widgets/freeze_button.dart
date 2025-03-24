import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';

class FreezeButton extends StatefulWidget {
  const FreezeButton({
    super.key,
  });

  @override
  State<FreezeButton> createState() => _FreezeButtonState();
}

class _FreezeButtonState extends State<FreezeButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is FreezeToggleSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              setState(() {});
            }
            if (state is FreezeToggleErrorState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
              setState(() {});
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: state is FreezeToggleLoadingState
                  ? const CustomLoadingIndicator()
                  : CustomElevatedButton(
                      text: context.read<GlobalCubit>().freeze == 1
                          ? "unfreeze".tr(context)
                          : "freeze".tr(context),
                      onPressed: () async {
                        await context.read<HomeCubit>().freezeToggle(context,
                            context.read<GlobalCubit>().freeze == 1 ? 0 : 1);
                        setState(() {});
                      },
                      heigth: 40.h,
                    ),
            );
          },
        );
      },
    );
  }
}
