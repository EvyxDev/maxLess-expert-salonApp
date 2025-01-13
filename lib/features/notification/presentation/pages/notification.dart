import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/component/custom-notification.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "title": "Protein session #123456789",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "image": "./lib/assets/feminism.png",
    },
    {
      "title": "After care session #123456789",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "image": "./lib/assets/testProducts.png",
    },
    {
      "title": "Protein session #123456789",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "image": "./lib/assets/feminism.png",
    },
    {
      "title": "After care session #123456789",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "image": "./lib/assets/testProducts.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Custom Header
          SizedBox(height: 20.h),

          CustomHeader(
            title: "Notification",
            onBackPress: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 10.h),

          // Notification List
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(), // يجعل التمرير أكثر سلاسة

              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateTo(context, RequestsScreen());
                      },
                      child: NotificationCard(
                        imageUrl: notification["image"]!,
                        title: notification["title"]!,
                        description: notification["description"]!,
                      ),
                    ),
                    Divider(
                      height: 30.h,
                      thickness: 1,
                      color: Colors.black12,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
