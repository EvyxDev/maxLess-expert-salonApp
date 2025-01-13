import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class RequestCard extends StatefulWidget {
  final bool completed;

  RequestCard({required this.completed});

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
          // Date
          Text(
            "5 April 2023",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xff525252),
            ),
          ),
          SizedBox(height: 8.h),

          // Service and Time
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

          // Customer Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget
                  .completed) // Only show the arrow icon if not completed
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

          // Expanded Section
          // Expanded Section
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location Link
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
                        SizedBox(height: 8.h),

                        // Description
                        Text(
                          "service_description".tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Buttons (Cancel or Accept/Reject)
                        // Buttons (Cancel or Accept/Reject)
                        if (widget.completed)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    print("Accepted");
                                    Fluttertoast.showToast(
                                      msg: "toast_request_accepted".tr(context),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      fontSize: 16.sp,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Text(
                                    "accept_button".tr(context),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    print("Rejected");
                                    _showCancelDialog(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: AppColors.primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Text(
                                    "reject_button".tr(context),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    print("Cancelled");
                                    Fluttertoast.showToast(
                                      msg:
                                          "toast_request_cancelled".tr(context),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      fontSize: 16.sp,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: AppColors.primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Text(
                                    "cancel_button".tr(context),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  // مربع الحوار للتأكيد على الإلغاء

  void _showCancelDialog(
    BuildContext context,
  ) {
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
            color: Colors.black,
          ),
        ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "cancel_dialog_yes".tr(context),
                  color: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog

                    // عرض التوست
                    Fluttertoast.showToast(
                      msg: "toast_request_rejected".tr(context),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.sp,
                    );
                  },
                ),
              ),
              SizedBox(width: 10.h), // مسافة بين الأزرار
              Expanded(
                child: CustomElevatedButton(
                  text: "cancel_dialog_no".tr(context),
                  borderRadius: 10,
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
