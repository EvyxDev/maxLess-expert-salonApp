import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/component/custom-notification.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "beauty_expert_notification_title".tr(context), // نص ديناميكي
        "description":
            "beauty_expert_notification_description".tr(context), // نص ديناميكي
        "image": "./lib/assets/feminism.png",
      },
      {
        "title": "order_shipped_notification_title".tr(context), // نص ديناميكي
        "description":
            "order_shipped_notification_description".tr(context), // نص ديناميكي
        "image": "./lib/assets/testProducts.png",
      },
      {
        "title":
            "order_confirmed_notification_title".tr(context), // نص ديناميكي
        "description": "order_confirmed_notification_description"
            .tr(context), // نص ديناميكي
        "image": "./lib/assets/testProducts2.png",
      },
      {
        "title": "hot_sale_notification_title".tr(context), // نص ديناميكي
        "description":
            "hot_sale_notification_description".tr(context), // نص ديناميكي
        "image": "./lib/assets/testProduct.png",
      },
      {
        "title": "order_canceled_notification_title".tr(context), // نص ديناميكي
        "description": "order_canceled_notification_description"
            .tr(context), // نص ديناميكي
        "image": "./lib/assets/test.png",
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Custom Header
          SizedBox(height: 20.h),

          CustomHeader(
            title: "notification_title".tr(context),
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
