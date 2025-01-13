import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/presentation/pages/login.dart';
import 'package:maxless/features/history/presentation/pages/history.dart';
import 'package:maxless/features/profile/presentation/pages/community.dart';
import 'package:maxless/features/profile/presentation/pages/expert-profile.dart';
import 'package:maxless/features/profile/presentation/pages/wallet.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';

class Sidebar extends StatelessWidget {
  bool isArabic = sl<CacheHelper>().getCachedLanguage() == 'ar';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // العنوان
          CustomHeader(
            title: "",
            onBackPress: () {
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            onTap: () {
              navigateTo(context, ExpertProfilePage());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: context.read<GlobalCubit>().isExpert
                        ? AssetImage('lib/assets/profile.png')
                        : AssetImage('lib/assets/1.png'),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read<GlobalCubit>().isExpert
                              ? "May Ahmed"
                              : "Beauty Loft Salon",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          context.read<GlobalCubit>().isExpert
                              ? "Mayahmed@gmail.com"
                              : "BeautyLoft@gmail.com",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 14.sp,
                              color: Color(0xffF5BE00),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: _buildLanguageField(context),
          ),
          // Navigation Items
          _buildNavItem(
            context,
            icon: "lib/assets/icons/new/req.svg",
            label: "requests_title".tr(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RequestsScreen()),
              );
            },
          ),
          _buildNavItem(
            context,
            icon: "lib/assets/icons/new/history.svg",
            label: "history_title".tr(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryScreen()),
              );
            },
          ),
          _buildNavItem(
            context,
            icon: "lib/assets/icons/new/community.svg",
            label: "community_title".tr(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CommunityPage()),
              );
            },
          ),

          // _buildNavItem(
          //   context,
          //   icon: "lib/assets/icons/new/wallet.svg",
          //   label: "Wallet",
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => WalletPage()),
          //     );
          //   },
          // ),

          // Logout
          _buildNavItem(
            context,
            icon: "lib/assets/icons/new/logout.svg",
            label: "logout_option_title".tr(context),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              _showCancelDialog(context);
              log("message");
            },
            iconColor: AppColors.primaryColor,
          ),
          // Spacer(),
          // Privacy Policy and Help
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.privacy_tip,
                      color: Color(0xff9C9C9C),
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "privacy_policy".tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.question_circle_fill,
                      color: Color(0xff9C9C9C),
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "help".tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required String icon,
      required String label,
      required VoidCallback onTap,
      Color iconColor = Colors.black}) {
    bool isRTL = Directionality.of(context) == TextDirection.ltr;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.h,
        horizontal: 20.w,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0.h,
            ),
            leading: SvgPicture.asset(icon, width: 20.w),
            minLeadingWidth: 5.w,
            title: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Icon(
                  isRTL
                      ? CupertinoIcons
                          .chevron_forward // إذا كانت RTL، يظهر سهم للخلف
                      : CupertinoIcons.chevron_back,
                  color: Color(0xff525252),
                  size: 18.sp,
                )
              ],
            ),
            onTap: onTap,
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        title: Text(
          "logout_confirmation_message".tr(context), // نص ديناميكي
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "yes_button".tr(context),
                  color: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () {
                    navigateTo(context, Login());
                  },
                ),
              ),
              SizedBox(width: 10.h), // مسافة بين الأزرار

              Expanded(
                child: CustomElevatedButton(
                  text: "no_button".tr(context),
                  borderRadius: 10,
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context); // إغلاق المودال
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageField(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isArabic = sl<CacheHelper>().getCachedLanguage() == 'ar';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "change_language".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            CupertinoSwitch(
              value: isArabic,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  isArabic = value;
                });

                sl<GlobalCubit>().changeLanguage();

                // عرض Snackbar لإعلام المستخدم بالتغيير
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${"language_changed_to".tr(context)} ${isArabic ? "العربية" : "English"}",
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
