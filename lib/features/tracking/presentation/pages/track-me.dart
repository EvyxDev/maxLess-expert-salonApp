import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/history/presentation/pages/history.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';
import 'package:maxless/features/reservation/presentation/pages/scan-qr.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isTracking = false; // حالة التتبع
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SizedBox(height: 20.h),

          // العنوان
          CustomHeader(
            title: "track_title".tr(context),
            onBackPress: () {
              Navigator.pop(context);
            },
          ),

          // محتوى الشاشة
          Expanded(
            child: Stack(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x80EEEEEE),
                          offset: Offset(0, 1),
                          blurRadius: 9,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                color: AppColors.primaryColor,
                                size: 35.sp,
                              ),
                              onPressed: () {
                                _showCancelDialog(context);
                              },
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      "20 min",
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.directions_walk,
                                      color: AppColors.primaryColor,
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      "1.4 km",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "1:40 PM",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // زر التتبع
                        CustomElevatedButton(
                          text: isTracking
                              ? "tracking_button_done".tr(context)
                              : "tracking_button_track_me".tr(context),
                          color: isTracking
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          borderColor: isTracking
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          borderRadius: 8,
                          onPressed: () {
                            setState(() {
                              isTracking = !isTracking;
                              isTracking
                                  ? null
                                  : navigateTo(context, ScanQRPage());
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // مربع الحوار للتأكيد على الإلغاء
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text(
          "cancel_dialog_title".tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        // content: Text(
        //   "You will not be able to reply to this chat again.",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 12.sp,
        //     fontWeight: FontWeight.w400,
        //     color: AppColors.primaryColor,
        //   ),
        // ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    Navigator.pop(context); // Close the dialog
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CartPage()),
                    //   (route) =>
                    //       route.isFirst, // يبقي فقط أول صفحة (عادةً صفحة Home)
                    // );
                    _showReasonDialog(context);
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

  void _showReasonDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    bool isEmergencyChecked = false; // Track checkbox state

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              alignment: Alignment.center,
              title: Text(
                "reason_dialog_title".tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff09031B),
                ),
              ),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TextField for custom reason
                    TextField(
                      controller: reasonController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "reason_dialog_checkbox".tr(context),
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 16.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Checkbox for predefined reason
                    Row(
                      children: [
                        Checkbox(
                          value: isEmergencyChecked,
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          checkColor: AppColors.white,
                          onChanged: (value) {
                            setState(() {
                              isEmergencyChecked = value ?? false;
                              if (isEmergencyChecked) {
                                reasonController.text =
                                    "reason_dialog_checkbox".tr(context);
                              } else {
                                reasonController
                                    .clear(); // Clear reason if unchecked
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "reason_dialog_checkbox".tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        text: "reason_dialog_send_button".tr(context),
                        color: AppColors.primaryColor,
                        borderRadius: 10,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          navigateTo(context, HistoryScreen());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
