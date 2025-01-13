import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> events = [
    {
      "time": "9:00 AM - 10:00 AM",
      "service": "Service Name",
      "customer": "Customer Name",
      "avatar": 'lib/assets/profile.png',
      "color": Colors.orange,
    },
    {
      "time": "11:00 AM - 12:00 PM",
      "service": "Service Name",
      "customer": "Customer Name",
      "avatar": 'lib/assets/profile.png',
      "color": Colors.green,
    },
    {
      "time": "2:00 PM - 3:00 PM",
      "service": "Service Name",
      "customer": "Customer Name",
      "avatar": 'lib/assets/profile.png',
      "color": Colors.purple,
    },
  ];

  final List<String> hours = [
    "9AM",
    "10AM",
    "11AM",
    "12PM",
    "1PM",
    "2PM",
    "3PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Ongoing",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: hours.length,
                itemBuilder: (context, index) {
                  final hour = hours[index];
                  final event = events.firstWhere(
                    (e) => e["time"].startsWith(hour),
                    orElse: () => {
                      "time": "",
                      "service": "",
                      "customer": "",
                      "avatar": "",
                      "color": Colors.transparent
                    },
                  );

                  return Column(
                    children: [
                      // Divider للأوقات الفارغة
                      if (event == null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Text(
                                hour,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // إذا كان هناك حدث في هذا الوقت
                      if (event != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hour,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Column(
                                children: [
                                  Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  if (index != hours.length - 1)
                                    Container(
                                      width: 2.w,
                                      height: 50.h,
                                      color: Colors.pink,
                                    ),
                                ],
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: event["color"],
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event["service"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        event["customer"],
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 15.r,
                                            backgroundImage:
                                                AssetImage(event["avatar"]),
                                          ),
                                          Text(
                                            event["time"],
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
