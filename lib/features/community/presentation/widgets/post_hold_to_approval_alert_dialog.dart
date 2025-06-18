import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';

class PostHoldToApprovalAlertDialog extends StatefulWidget {
  const PostHoldToApprovalAlertDialog({
    super.key,
  });

  @override
  State<PostHoldToApprovalAlertDialog> createState() =>
      _PostHoldToApprovalAlertDialogState();
}

class _PostHoldToApprovalAlertDialogState
    extends State<PostHoldToApprovalAlertDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      // ignore: use_build_context_synchronously
      () => mounted ? Navigator.pop(context) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 327.w,
        padding: EdgeInsets.symmetric(vertical: 31.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "lib/assets/icons/check.svg",
              height: 69.h,
            ),
            SizedBox(height: 25.h),
            Text(
              "YourPostHasBeenPutOnHoldForApproval".tr(context),
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
