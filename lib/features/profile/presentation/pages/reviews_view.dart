import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/profile/presentation/cubit/profile_cubit.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getReviews(id: userId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is GetReviewsErrorState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();
            return Column(
              children: [
                SizedBox(height: 20.h),
                //! Header
                CustomHeader(
                  title: "reviews_label".tr(context),
                  onBackPress: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 10.h),
                //! Reviews
                Expanded(
                  child: state is GetReviewsLoadingState
                      ? const Center(child: CustomLoadingIndicator())
                      : ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          children: List.generate(
                            cubit.reviews.length,
                            (index) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 14.h,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: 34.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFBFBFB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    //! Reviewer Details
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          //! User Image
                                          SizedBox(
                                            height: 35.h,
                                            width: 35.h,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                cubit.reviews[index].image ??
                                                    "",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    height: 35.h,
                                                    width: 35.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Text(
                                              cubit.reviews[index].expertId ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                          //! Created At
                                          Text(
                                            cubit.reviews[index].createdAt
                                                    ?.split("T")
                                                    .first ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    //! Review
                                    cubit.reviews[index].review != null
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10.h),
                                            child: Text(
                                              cubit.reviews[index].review!,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    //! Rating
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        5,
                                        (starIndex) {
                                          double starValue = starIndex + 1;
                                          return Icon(
                                            starValue <=
                                                    (cubit.reviews[index]
                                                            .rate ??
                                                        0)
                                                ? Icons.star
                                                : starValue - 0.5 <=
                                                        (cubit.reviews[index]
                                                                .rate ??
                                                            0)
                                                    ? Icons.star_half
                                                    : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16.sp,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
