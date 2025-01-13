import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class HistoryCard extends StatefulWidget {
  final bool completed;

  HistoryCard({required this.completed});

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut, // اجعل الأنيميشن سموث
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: Color(0xffFFE2EC),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "5 April 2023",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xff525252),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "service_name".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                "9:00 AM - 10:00 AM",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xff525252),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.completed)
                Icon(
                  isExpanded
                      ? CupertinoIcons.arrow_up_left
                      : CupertinoIcons.arrow_down_right,
                  color: Color(0xff9C9C9C),
                  size: 20.sp,
                ),
              if (!widget.completed) SizedBox(width: 8.w),
              CircleAvatar(
                radius: 18.r,
                backgroundImage: AssetImage('lib/assets/profile.png'),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "customer_name".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(
                  isExpanded
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: Color(0xff9C9C9C),
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut, // منحنى التحريك
            child: isExpanded
                ? Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(CupertinoIcons.location, size: 14.sp),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                "https://maps.app.goo.gl/JddP2...",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "service_description".tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
