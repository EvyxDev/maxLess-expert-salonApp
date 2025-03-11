import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/locale/app_loacl.dart';

Future<ImageSource?> pickeImageSourceBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => Container(
      width: double.infinity,
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //! Camera
          PickImageSourceButton(
            onTap: () => Navigator.pop(context, ImageSource.camera),
            title: AppStrings.takeAPhoto.tr(context),
            icon: Icons.camera_alt,
          ),
          // //! Gallery
          PickImageSourceButton(
            onTap: () => Navigator.pop(context, ImageSource.gallery),
            title: AppStrings.chooseFromGallery.tr(context),
            icon: Icons.image,
          ),
        ],
      ),
    ),
  );
}

class PickImageSourceButton extends StatelessWidget {
  const PickImageSourceButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  final Function() onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335.w,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.h,
              color: AppColors.white,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
