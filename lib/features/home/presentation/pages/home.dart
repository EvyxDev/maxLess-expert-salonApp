import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/side_bar.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';
import 'package:maxless/features/home/presentation/widgets/custom_calender_home.dart';
import 'package:maxless/features/home/presentation/widgets/home_booking_card.dart';
import 'package:maxless/features/home/presentation/widgets/home_header.dart';

class HomePage extends StatelessWidget {
  // final Color backgroundColor = const Color(0xFFFFE2EC);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..init(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            drawer: const Sidebar(),
            key: _scaffoldKey,
            backgroundColor: const Color(0xFFFFE2EC),
            body: CustomModalProgressIndicator(
              inAsyncCall: state is GetBookingByDateLoadingState ? true : false,
              child: SafeArea(
                child: Column(
                  children: [
                    // الهيدر والتقويم
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.h),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE2EC),
                      ),
                      child: Column(
                        children: [
                          //! Header
                          HomeHeader(
                            drawerOnTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),

                          SizedBox(height: 20.h),

                          //! Date
                          SizedBox(
                            height: 200.h,
                            child: const HomeCalendar(),
                          ),
                        ],
                      ),
                    ),

                    // Bokkings
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                "ongoing_title".tr(context),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),

                            // الجدولة
                            Expanded(
                              child: state is GetBookingByDateLoadingState
                                  ? Container()
                                  : cubit.bookings.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: cubit.bookings.length,
                                          itemBuilder: (context, index) {
                                            final colors = [
                                              const Color(0xffFFB017),
                                              const Color(0xff42CF96),
                                              const Color(0xffE48FFF),
                                            ];
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 8.h),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //! Time Section
                                                      Column(
                                                        children: [
                                                          //! Start Time
                                                          Text(
                                                            cubit.formateTime(cubit
                                                                    .bookings[
                                                                        index]
                                                                    .expertSlot
                                                                    ?.start ??
                                                                "00:00:00"),
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xff585A66),
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          Container(
                                                            width: 2.w,
                                                            height: 100.h,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5), // الخط الرابط
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          //! End Time
                                                          Text(
                                                            cubit.formateTime(cubit
                                                                    .bookings[
                                                                        index]
                                                                    .expertSlot
                                                                    ?.end ??
                                                                "00:00:00"),
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xff585A66),
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 16.w),

                                                      //! Card
                                                      HomeBookingCard(
                                                          model: cubit
                                                              .bookings[index],
                                                          color: colors[index %
                                                              colors.length]),
                                                    ],
                                                  ),

                                                  SizedBox(height: 20.h),

                                                  //! Bottom Line
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // الوقت على اليسار
                                                      Text(
                                                        cubit.formateTime(cubit
                                                                .bookings[index]
                                                                .expertSlot
                                                                ?.end ??
                                                            "00:00:00"),
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xff585A66),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),

                                                      // النقطة والخط
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            // النقطة
                                                            Container(
                                                              width: 10.w,
                                                              height: 10.h,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            // الخط
                                                            Expanded(
                                                              child: Container(
                                                                height: 2.h,
                                                                color: AppColors
                                                                    .primaryColor, // نفس لون النقطة
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            child: Text(
                                              AppStrings.noBookingForThisDay
                                                  .tr(context),
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
