// profile_option.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/constants/app_colors.dart';

class ProfileOption extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor; // لون النص اختياري

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor, // يتم تمرير اللون إذا كان موجودًا
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: SvgPicture.asset(
              icon,
              width: 24.w, // عرض الأيقونة
              height: 24.h, // ارتفاع الأيقونة
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: textColor ??
                    Colors.black, // إذا لم يتم تمرير لون، استخدم الأسود
              ),
            ),
            trailing: Icon(CupertinoIcons.chevron_forward,
                color: Colors.grey, size: 16.sp),
            onTap: onTap,
          ),
          Divider(
            height: 20.h,
            thickness: 2,
            color: Color(0xffF2F2F2),
          ),
        ],
      ),
    );
  }
}
