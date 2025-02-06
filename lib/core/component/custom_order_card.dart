import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';

class OrderCard extends StatelessWidget {
  final String imageUrl;
  final String orderId;
  final String status;
  final String date;
  final String price;
  final int items;

  const OrderCard({
    super.key,
    required this.imageUrl,
    required this.orderId,
    required this.status,
    required this.date,
    required this.price,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Shape with Image
          Container(
            width: 90.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: const DecorationImage(
                image:
                    AssetImage('./lib/assets/icons/shape.png'), // shape خلفية
                fit: BoxFit.contain,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: -5.h,
                  child: Image.asset(
                    imageUrl,
                    height: 65.h,
                    width: 50.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                Text(
                  "Order ID $orderId",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 4.h),
                // Items and Status
                Text(
                  "$items items",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff525252),
                  ),
                ),
                SizedBox(height: 4.h),
                // Items and Status
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff525252),
                  ),
                ),
                SizedBox(height: 4.h),
                // Date
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          // Price
          Text(
            price,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
