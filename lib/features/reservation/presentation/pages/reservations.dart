import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/reservation_card.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/features/chatting/presentation/pages/customer_service_chat.dart';
import 'package:maxless/features/profile/presentation/pages/expert_profile.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            SizedBox(height: 20.h),
            CustomHeader(
              title: "Reservations",
              onBackPress: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // خلفية التابات
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: TabBar(
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Colors.white,
                  indicator: BoxDecoration(
                    color: Colors.white, // لون التاب المحدد
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  indicatorSize:
                      TabBarIndicatorSize.tab, // جعل المؤشر يأخذ عرض التاب
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,

                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                  tabs: const [
                    Tab(text: "Salons"),
                    Tab(text: "Experts"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNestedTabs(title: "Salons"),
                  _buildNestedTabs(title: "Experts"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNestedTabs({required String title}) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
              // indicator: BoxDecoration(
              //   color: Colors.transparent,
              // ),
              indicatorColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "Completed"),
                Tab(text: "Pending"),
                Tab(text: "Canceled"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildReservationsList(
                  status: "Completed",
                  reservations: _getReservationsForStatus("Completed", title),
                ),
                _buildReservationsList(
                  status: "Pending",
                  reservations: _getReservationsForStatus("Pending", title),
                ),
                _buildReservationsList(
                  status: "Canceled",
                  reservations: _getReservationsForStatus("Canceled", title),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList({
    required String status,
    required List<Map<String, String>> reservations,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: reservations.isEmpty
          ? Center(
              child: Text(
                "No $status Reservations",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.separated(
              itemCount: reservations.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return ReservationCard(
                  status: status,
                  name: reservation["name"]!,
                  date: reservation["date"]!,
                  time: reservation["time"]!,
                  image: reservation["image"],
                  isExpandable: status == "Pending",
                  onViewProfile: () {
                    navigateTo(context, const ExpertProfilePage());
                  },
                  onCancel: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Are you sure you want to cancel the reservation?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: double.infinity, // عرض الزر بالكامل
                                    child: CustomElevatedButton(
                                      text: "Customer Service",
                                      color: AppColors.primaryColor,
                                      borderRadius: 10.r,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // print("Customer Service");
                                        navigateTo(context,
                                            const CustomerServiceChat());
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  SizedBox(
                                    width: double.infinity, // عرض الزر بالكامل
                                    child: CustomElevatedButton(
                                      text: "Cancel",
                                      borderColor: AppColors.primaryColor,
                                      borderRadius: 10.r,
                                      color: Colors.white,
                                      textColor: AppColors.primaryColor,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // print("Order Canceled");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  List<Map<String, String>> _getReservationsForStatus(
      String status, String category) {
    if (category == "Salons") {
      if (status == "Completed") {
        return [
          {
            "name": "Beauty Loft Salon",
            "date": "5 April 2023",
            "time": "9:00 AM - 10:00 AM",
            "image": "./lib/assets/1.png",
          },
          {
            "name": "Yasmina Beauty Salon",
            "date": "5 April 2023",
            "time": "9:00 AM - 10:00 AM",
            "image": "./lib/assets/2.png",
          },
        ];
      } else if (status == "Pending") {
        return [
          {
            "name": "Beauty Loft Salon",
            "date": "5 April 2023",
            "time": "9:00 AM - 10:00 AM",
            "image": "./lib/assets/1.png",
          },
        ];
      } else if (status == "Canceled") {
        return [
          {
            "name": "Yasmina Beauty Salon",
            "date": "10 April 2023",
            "time": "11:00 AM - 12:00 PM",
            "image": "./lib/assets/2.png",
          },
        ];
      }
    } else if (category == "Experts") {
      if (status == "Completed") {
        return [
          {
            "name": "Layla Omar",
            "date": "5 April 2023",
            "time": "9:00 AM - 10:00 AM",
            "image": "./lib/assets/post.png",
          },
        ];
      } else if (status == "Pending") {
        return [
          {
            "name": "Maha Hossam",
            "date": "6 April 2023",
            "time": "11:00 AM - 12:00 PM",
            "image": "./lib/assets/expert.png",
          },
        ];
      } else if (status == "Canceled") {
        return [
          {
            "name": "Sally Nabil",
            "date": "7 April 2023",
            "time": "4:00 PM - 5:00 PM",
            "image": "././lib/assets/expert.png",
          },
        ];
      }
    }
    return [];
  }
}
