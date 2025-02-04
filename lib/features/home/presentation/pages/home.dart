import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom-calender-home.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/auth/presentation/pages/get-location.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/side-bar.dart';
import 'package:maxless/features/notification/presentation/pages/notification.dart';
import 'package:maxless/features/community/presentation/screens/community.dart';
import 'package:maxless/features/reservation/presentation/pages/scan-qr-salon.dart';
import 'package:maxless/features/tracking/presentation/pages/track-me.dart';

class HomePage extends StatelessWidget {
  final Color backgroundColor = Color(0xFFFFE2EC);
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // المفتاح للتحكم في الـ Drawer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      key: _scaffoldKey, // ربط المفتاح بـ Scaffold

      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر والتقويم
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: Column(
                children: [
                  // الهيدر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState
                              ?.openDrawer(); // فتح القائمة الجانبية
                        },
                        child: Directionality.of(context) == TextDirection.rtl
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
                            iconPath: "lib/assets/icons/new/notifications.svg",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NotificationPage()),
                              );
                            },
                          ),
                          SizedBox(width: 10.w),
                          _buildCircularButton(
                            iconPath: "lib/assets/icons/new/community.svg",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CommunityPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // التقويم
                  Container(
                    height: 200.h, // تحديد ارتفاع التقويم
                    child: HomeCalendar(), // عرض مكون التقويم الديناميكي
                  ),
                ],
              ),
            ),

            // المحتوى
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
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final colors = [
                            Color(0xffFFB017),
                            Color(0xff42CF96),
                            Color(0xffE48FFF),
                          ];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // قسم التوقيت
                                    Column(
                                      children: [
                                        Text(
                                          "${"1:40"} ${"am".tr(context)}",
                                          style: TextStyle(
                                              color: Color(0xff585A66),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          width: 2.w,
                                          height: 100.h,
                                          color: Colors.grey
                                              .withOpacity(0.5), // الخط الرابط
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          "${"1:40"} ${"am".tr(context)}",
                                          style: TextStyle(
                                              color: Color(0xff585A66),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16.w),

                                    // الكارد الرئيسي
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showCustomPopup(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: colors[index],
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x1C252C).withOpacity(
                                                    0.08), // اللون مع الشفافية (#1C252C14)
                                                blurRadius: 23, // مدى التمويه
                                                spreadRadius: 0, // مدى الانتشار
                                                offset: Offset(
                                                    0, 14), // الإزاحة (x, y)
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(16.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "service_name".tr(context),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                "customer_name".tr(context),
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  AnimatedContainer(
                                                    duration: Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1.w,
                                                            color:
                                                                Colors.white),
                                                        shape: BoxShape.circle),
                                                    child: CircleAvatar(
                                                      radius: 20.r,
                                                      backgroundImage: AssetImage(
                                                          'lib/assets/profile.png'),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${"1:40"} ${"am".tr(context)}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        "${"1:40"} ${"pm".tr(context)}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // الوقت على اليسار
                                    Text(
                                      "${"1:40"} ${"am".tr(context)}",
                                      style: TextStyle(
                                        color: Color(0xff585A66),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                        width: 10.w), // مسافة بين الوقت والنقطة

                                    // النقطة والخط
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // النقطة
                                          Container(
                                            width: 10.w,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              shape: BoxShape.circle,
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
                    border: Border.all(width: 2.w, color: Color(0xffFFB017))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h), // مساحة للشعار العلوي
                    // النص الوصفي
                    Text(
                      "service_name".tr(context),
                      style: TextStyle(
                        color: Color(0xFFB2284C),
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
                          backgroundImage: AssetImage('lib/assets/profile.png'),
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
                                ? navigateTo(context, LocationScreen())
                                : navigateTo(context, ScanQRSalon());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFB2284C),
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
                    color: Color(0xffFFB017), // لون الديفايدر البرتقالي
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
