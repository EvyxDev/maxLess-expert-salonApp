import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/side_bar.dart';
import 'package:maxless/features/community/presentation/screens/community.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';
import 'package:maxless/features/home/presentation/widgets/custom_calender_home.dart';
import 'package:maxless/features/notification/presentation/pages/notification.dart';
import 'package:maxless/features/reservation/presentation/pages/scan_qr_salon.dart';
import 'package:maxless/features/tracking/presentation/pages/track_me.dart';

class HomePage extends StatelessWidget {
  final Color backgroundColor = const Color(0xFFFFE2EC);
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
            backgroundColor: backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  // الهيدر والتقويم
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        //! Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState
                                    ?.openDrawer(); // فتح القائمة الجانبية
                              },
                              child: Directionality.of(context) ==
                                      TextDirection.rtl
                                  ? SvgPicture.asset("lib/assets/sidrtl.svg")
                                  : Image.asset(
                                      "lib/assets/icons/new/menu.png",
                                      width: 19.w,
                                      height: 16.w,
                                    ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "home_title".tr(context),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                _buildCircularButton(
                                  iconPath:
                                      "lib/assets/icons/new/notifications.svg",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const NotificationPage()),
                                    );
                                  },
                                ),
                                SizedBox(width: 10.w),
                                _buildCircularButton(
                                  iconPath:
                                      "lib/assets/icons/new/community.svg",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const CommunityPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
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
                                ? const CustomLoadingIndicator()
                                : RefreshIndicator(
                                    color: AppColors.primaryColor,
                                    onRefresh: () {
                                      return cubit.init();
                                    },
                                    child: cubit.bookings.isNotEmpty
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
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            Container(
                                                              width: 2.w,
                                                              height: 100.h,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5), // الخط الرابط
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
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
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              showCustomPopup(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: colors[
                                                                    index],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(
                                                                            0xff1C252C)
                                                                        .withOpacity(
                                                                            0.08),
                                                                    blurRadius:
                                                                        23,
                                                                    spreadRadius:
                                                                        0,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          16.w),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  // Text(
                                                                  //   "service_name"
                                                                  //       .tr(context),
                                                                  //   style: TextStyle(
                                                                  //     color: Colors.white,
                                                                  //     fontSize: 16.sp,
                                                                  //     fontWeight:
                                                                  //         FontWeight.bold,
                                                                  //   ),
                                                                  // ),
                                                                  // SizedBox(height: 4.h),
                                                                  //! User Name
                                                                  Text(
                                                                    cubit
                                                                            .bookings[index]
                                                                            .user
                                                                            ?.name ??
                                                                        "...",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10.h),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      AnimatedContainer(
                                                                        duration:
                                                                            const Duration(
                                                                          milliseconds:
                                                                              300,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1.w, color: Colors.white),
                                                                            shape: BoxShape.circle),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              60.h,
                                                                          width:
                                                                              60.h,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(50),
                                                                            child:
                                                                                Image.network(
                                                                              cubit.bookings[index].user?.image ?? "",
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                return const Icon(Icons.error_outline);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              10.w),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            cubit.formateTime(cubit.bookings[index].expertSlot?.start ??
                                                                                "00:00:00"),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12.sp,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10.w),
                                                                          Text(
                                                                            cubit.formateTime(cubit.bookings[index].expertSlot?.end ??
                                                                                "00:00:00"),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12.sp,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
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
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: 10
                                                                .w), // مسافة بين الوقت والنقطة

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
                                                                child:
                                                                    Container(
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
                                        : Expanded(
                                            child: Center(
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
                                          )),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircularButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          SvgPicture.asset(
            iconPath,
            width: 24.w,
            height: 24.h,
          ),
        ],
      ),
    );
  }

  void showCustomPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // الحواف الدائرية
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9, // العرض النسبي
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border:
                        Border.all(width: 2.w, color: const Color(0xffFFB017))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h), // مساحة للشعار العلوي
                    // النص الوصفي
                    Text(
                      "service_name".tr(context),
                      style: TextStyle(
                        color: const Color(0xFFB2284C),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "service_description".tr(innerContext),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // معلومات العميل
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage:
                              const AssetImage('lib/assets/profile.png'),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "customer_name".tr(innerContext),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // فتح الرابط
                                },
                                child: Text(
                                  "https://maps.app.goo.gl",
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
                                  ? "start_the_way_button".tr(innerContext)
                                  : "start_button".tr(innerContext),
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
      },
    );
  }
}
