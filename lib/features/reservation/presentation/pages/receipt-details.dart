import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class ReceiptDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            CustomHeader(
              title: "receipt_details".tr(context),
              onBackPress: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      // صورة الملف الشخصي
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          "./lib/assets/1.png",
                          height: 60.h,
                          width: 60.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // النصوص
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Beauty Loft Salon",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              size: 16.sp,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "https://maps.app.goo.gl",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                          ]),
                          SizedBox(height: 4.h),
                          Row(children: [
                            Icon(
                              CupertinoIcons.phone_fill,
                              size: 16.sp,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "0123456789",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildSectionTitle("your_booking".tr(context)),
                  SizedBox(height: 10.h),
                  _buildBookingDetails(context),
                  SizedBox(height: 20.h),
                  _buildDashedDivider(),
                  SizedBox(height: 20.h),
                  _buildSectionTitle("price_details".tr(context)),
                  SizedBox(height: 10.h),
                  _buildPriceDetails(context),
                  SizedBox(height: 20.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xffFFE2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
              CupertinoIcons.calendar, "dates".tr(context), "12 - 14 Nov 2024"),
          // SizedBox(height: 10.h),
          // _buildDetailRow(CupertinoIcons.time, "Session duration", "4 hours"),
          SizedBox(height: 10.h),
          _buildDetailRow(
              CupertinoIcons.time, "start_session".tr(context), "12:00 PM"),
          SizedBox(height: 10.h),
          _buildDetailRow(
              CupertinoIcons.time, "end_session".tr(context), "4:00 PM"),
          SizedBox(height: 10.h),
          _buildDetailRow(
              CupertinoIcons.phone, "phone".tr(context), "021434546"),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xffFFE2EC)),
      ),
      child: Column(
        children: [
          _buildPriceRow("price".tr(context), "8000.00 LE"),
          SizedBox(height: 8.h),
          _buildDashedDivider(),
          SizedBox(height: 10.h),
          _buildPriceRow("discount".tr(context), "800.00 LE"),
          SizedBox(height: 8.h),
          _buildDashedDivider(),
          SizedBox(height: 10.h),
          _buildPriceRow("total_price".tr(context), "7200.00 LE", isBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Color(0xff9C9C9C)),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            color: isBold ? Colors.black : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return Container(
      width: double.infinity,
      height: 1.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashWidth = 5.w;
          final dashSpace = 3.w;
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dashCount,
              (index) => Container(
                width: dashWidth,
                height: 1.h,
                color: Colors.grey.shade400,
              ),
            ),
          );
        },
      ),
    );
  }
}
