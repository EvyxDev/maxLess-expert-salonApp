import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/data/models/answer_and_question_model.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/reservation/presentation/pages/scan_qr_salon.dart';
import 'package:maxless/features/tracking/presentation/pages/track_me.dart';

class HomeBookingCardDialog extends StatelessWidget {
  const HomeBookingCardDialog({
    super.key,
    required this.model,
  });

  final BookingItemModel model;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(width: 2.w, color: const Color(0xffFFB017)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                //! Service Title
                // النص الوصفي
                // Text(
                //   "service_name".tr(context),
                //   style: TextStyle(
                //     color: const Color(0xFFB2284C),
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: 10.h),
                //! Description
                ...List.generate(
                  model.answersAndQuestions.length,
                  (index) {
                    AnswerAndQuestionModel answerAndQuestionModel =
                        model.answersAndQuestions[index];
                    return Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${answerAndQuestionModel.question} : ${answerAndQuestionModel.answer}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                //! Client Details
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: .5.w, color: Colors.black),
                          shape: BoxShape.circle),
                      child: SizedBox(
                        height: 40.h,
                        width: 40.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            model.user?.image ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error_outline);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.user?.name ?? "",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (model.lat != null && model.lon != null)
                            GestureDetector(
                              onTap: () {
                                context.read<GlobalCubit>().launchGoogleMapLink(
                                      lat: model.lat!,
                                      lon: model.lon!,
                                    );
                              },
                              child: Text(
                                context
                                    .read<GlobalCubit>()
                                    .formateGoogleMapLink(
                                      lat: model.lat!,
                                      lon: model.lon!,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    //! Start Way Button
                    GestureDetector(
                      onTap: () {
                        context.read<GlobalCubit>().isExpert
                            ? navigateTo(context, const LocationScreen())
                            : navigateTo(context, const ScanQRSalon());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB2284C),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Text(
                          context.read<GlobalCubit>().isExpert
                              ? "start_the_way_button".tr(context)
                              : "start_button".tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // الشعار في الأعلى
          Positioned(
            top: 30.h,
            left: 20, // ضبط موضع الشعار
            child: Image.asset(
              'lib/assets/logo.png', // مسار الشعار
              width: 70.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
          ),

          // الديفايدر الجانبي
          Positioned(
            top: 10,
            left: -25,
            child: Container(
              width: 33.w,
              height: 104.h,
              decoration: BoxDecoration(
                color: const Color(0xffFFB017), // لون الديفايدر البرتقالي
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
