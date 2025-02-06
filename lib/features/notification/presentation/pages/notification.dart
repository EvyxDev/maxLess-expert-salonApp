import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/notification/presentation/cubit/notifications_cubit.dart';
import 'package:maxless/features/notification/presentation/widgets/notification_card.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..getExpertNotifications(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final cubit = context.read<NotificationsCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                //! Custom Header
                SizedBox(height: 20.h),
                CustomHeader(
                  title: "notification_title".tr(context),
                  onBackPress: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 10.h),

                //! Notification List
                Expanded(
                  child: state is GetNotificationsLoadingState
                      ? const CustomLoadingIndicator()
                      : cubit.notifications.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: cubit.notifications.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        navigateTo(
                                            context, const RequestsScreen());
                                      },
                                      child: NotificationCard(
                                        model: cubit.notifications[index],
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
                            )
                          : Center(
                              child: Text(
                                AppStrings.thereIsNoNotifications.tr(context),
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: const Color(0xff525252),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
