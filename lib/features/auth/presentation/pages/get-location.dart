import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';

class LocationAccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SizedBox(height: 20.h),

          // العنوان
          CustomHeader(
            title: "location_access_title".tr(context),
            onBackPress: () {
              Navigator.pop(context);
            },
          ),

          // محتوى الشاشة
          Expanded(
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة الخريطة
                Positioned.fill(
                  child: Image.asset(
                    'lib/assets/maps.png', // المسار الصحيح للصورة
                    fit: BoxFit.cover,
                    height: 500.h,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // لون خلفية الـ Container
                      borderRadius:
                          BorderRadius.circular(12), // الحواف الدائرية
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color(0x80EEEEEE), // لون الظل (بنسبة شفافية 50%)
                          offset: Offset(0, 1), // إزاحة الظل
                          blurRadius: 9, // نصف القطر (التشويش)
                          spreadRadius: 0, // مدى الانتشار
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // النص "Set Location"
                        Text(
                          "set_location_title".tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // الزر "Arrived"
                        CustomElevatedButton(
                          text: "use_current_location_button".tr(context),
                          color: AppColors.primaryColor,
                          borderColor: AppColors.primaryColor,
                          textColor: Colors.white,
                          borderRadius: 8,
                          icon: Icon(
                            CupertinoIcons.location_fill,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          onPressed: () {
                            navigateAndFinish(context, HomePage());
                          },
                        ),
                        SizedBox(height: 15.h),

                        // النص "Set Location"
                        Center(
                          child: Text(
                            "set_location_manually_text".tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
