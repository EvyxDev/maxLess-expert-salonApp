import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/profile/presentation/pages/expert-profile.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: context.read<GlobalCubit>().isExpert
                      ? AssetImage('./lib/assets/expert.png')
                      : AssetImage('lib/assets/1.png'),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
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
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildPostCard(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Color(0xffFBFBFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                navigateTo(context, ExpertProfilePage());
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: AssetImage('./lib/assets/expert.png'),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "expert_name".tr(context),
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
                  Spacer(),
                  Text(
                    "post_time".tr(context),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
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
                  "100".tr(context),
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
}
