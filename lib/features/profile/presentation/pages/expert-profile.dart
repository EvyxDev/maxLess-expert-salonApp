import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class ExpertProfilePage extends StatelessWidget {
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
              title: "community".tr(context),
              onBackPress: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.all(16.w),

              // padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundImage: context.read<GlobalCubit>().isExpert
                              ? AssetImage('./lib/assets/expert.png')
                              : AssetImage('lib/assets/1.png'),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          context.read<GlobalCubit>().isExpert
                              ? "May Ahmed"
                              : "Beauty Loft Salon",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return Icon(Icons.star,
                                color: index < 4 ? Colors.amber : Colors.grey,
                                size: 16.sp);
                          }),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "experience_label".tr(context), // نص ديناميكي
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "reviews_label".tr(context), // نص ديناميكي
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "2_years".tr(context), // نص ديناميكي
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "reviews_count".tr(context), // نص ديناميكي
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h), // مسافة بين النص والخط الفاصل
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade300, // لون الخط
                        ),
                      ],
                    ),
                  ),
                  Text("posts_title".tr(context),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Container(
                    // height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFBFBFB),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Color(0xffFFE2EC), width: 1),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none, // إزالة الحدود
                              hintText:
                                  "write_about_your_work_hint".tr(context),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.cloud_upload,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                          onPressed: () {
                            // حدث عند الضغط على زر الرفع
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...List.generate(3, (index) => _buildPostCard(context)),
                  SizedBox(height: 70.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFBFBFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: context.read<GlobalCubit>().isExpert
                      ? AssetImage('./lib/assets/expert.png')
                      : AssetImage('lib/assets/1.png'),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read<GlobalCubit>().isExpert
                              ? "May Ahmed"
                              : "Beauty Loft Salon",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "expert_location".tr(context),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10.w),
                        // أيقونة التعديل
                        GestureDetector(
                          onTap: () {
                            // منطق التعديل
                          },
                          child: Icon(
                            CupertinoIcons.pencil_ellipsis_rectangle,
                            size: 20.sp,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // أيقونة الحذف
                        GestureDetector(
                          onTap: () {
                            _showCancelDialog(context);
                          },
                          child: Icon(
                            CupertinoIcons.xmark,
                            size: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      "post_time".tr(context),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                './lib/assets/post.png',
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "post_description".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  CupertinoIcons.heart,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  "100",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text(
          "delete_post_confirmation".tr(context),
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
                  text: "yes_button".tr(context),
                  color: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog

                    // عرض التوست
                    Fluttertoast.showToast(
                      msg: "post_deleted_toast".tr(context),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.white,
                      textColor: AppColors.primaryColor,
                      fontSize: 16.sp,
                    );
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
