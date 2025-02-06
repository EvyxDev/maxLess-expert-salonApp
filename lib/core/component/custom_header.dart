import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPress;
  final Widget? trailing; // Optional trailing widget
  final bool? showPopButton;

  const CustomHeader({
    super.key,
    required this.title,
    required this.onBackPress,
    this.trailing, // Add this
    this.showPopButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: 16.h), // Adjust padding
      child: Container(
        margin: EdgeInsets.only(top: 25.h), // Responsive margin
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // العنوان في المنتصف
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp, // Responsive font size
                  color: const Color(0xff525252),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // زر الرجوع
            showPopButton != false
                ? Positioned(
                    left: Directionality.of(context) == TextDirection.rtl
                        ? null
                        : -34.w, // Adjust position for LTR
                    right: Directionality.of(context) == TextDirection.rtl
                        ? -34.w
                        : null, // Adjust position for RTL
                    child: GestureDetector(
                      onTap: onBackPress,
                      child: SvgPicture.asset(
                        Directionality.of(context) == TextDirection.rtl
                            ? "lib/assets/rtl.svg" // السهم مخصص لـ RTL
                            : "lib/assets/Back.svg", // السهم مخصص لـ LTR
                        width: 80.w, // Responsive width
                        height: 62.h, // Responsive height
                      ),
                    ),
                  )
                : Container(),
            // زر إضافي اختياري في أقصى اليمين
            if (trailing != null)
              Positioned(
                right: Directionality.of(context) == TextDirection.rtl
                    ? null
                    : 0, // Adjust position for LTR
                left: Directionality.of(context) == TextDirection.rtl
                    ? 0
                    : null, // Adjust position for RTL
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
