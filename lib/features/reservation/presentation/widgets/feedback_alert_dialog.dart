import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';

import '../cubit/session_cubit.dart';
import '../pages/receipt_details.dart';

class FeedbackAlertDialog extends StatefulWidget {
  const FeedbackAlertDialog({super.key});

  @override
  State<FeedbackAlertDialog> createState() => _FeedbackAlertDialogState();
}

class _FeedbackAlertDialogState extends State<FeedbackAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is FeedbackSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => context.read<GlobalCubit>().isExpert
                  ? HomePage()
                  : const ReceiptDetailsPage(),
            ),
            (route) => route.isFirst,
          );
        }
        if (state is FeedbackErrorState) {
          showToast(
            context,
            message: state.message,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SessionCubit>();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          content: PopScope(
            canPop: false,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 327.w,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: cubit.feedbackFromKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // العنوان الرئيسي
                        Text(
                          "rating_popup_title".tr(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // الوصف
                        Text(
                          context.read<GlobalCubit>().isSalon
                              ? "rate_salon_instruction".tr(context)
                              : "rate_session_instruction".tr(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // النجوم للتقييم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) {
                              return IconButton(
                                icon: Icon(
                                  index < cubit.rating
                                      ? CupertinoIcons.star_fill
                                      : CupertinoIcons.star,
                                  color: Colors.amber,
                                  size: 30.sp,
                                ),
                                onPressed: () {
                                  cubit.updateFeedback(index);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // حقل النص لإضافة تعليق
                        TextFormField(
                          maxLines: 4,
                          controller: cubit.feedbackController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppStrings.thisFieldIsRequired.tr(context);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "write_feedback".tr(context),
                            hintStyle:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        //! Send Button
                        state is FeedbackLoadingState
                            ? const CustomLoadingIndicator()
                            : CustomElevatedButton(
                                text: "send_button".tr(context),
                                color: AppColors.primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (cubit.feedbackFromKey.currentState!
                                      .validate()) {
                                    context.read<GlobalCubit>().isExpert
                                        ? cubit.expertSessionFeedback(context)
                                        : null;
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
