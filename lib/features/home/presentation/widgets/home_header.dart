import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/community/presentation/screens/community.dart';
import 'package:maxless/features/notification/presentation/pages/notification.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.drawerOnTap,
  });

  final Function() drawerOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: drawerOnTap,
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
                  MaterialPageRoute(builder: (_) => const NotificationPage()),
                );
              },
            ),
            SizedBox(width: 10.w),
            _buildCircularButton(
              iconPath: "lib/assets/icons/new/community.svg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommunityPage()),
                );
              },
            ),
          ],
        ),
      ],
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
}
