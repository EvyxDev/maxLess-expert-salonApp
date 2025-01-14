import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class AvailableDaysAndHoursSection extends StatefulWidget {
  @override
  _AvailableDaysAndHoursSectionState createState() =>
      _AvailableDaysAndHoursSectionState();
}

class _AvailableDaysAndHoursSectionState
    extends State<AvailableDaysAndHoursSection> {
  int selectedDayIndex = -1; // لتخزين اليوم المختار
  int selectedHourIndex = -1; // لتخزين الساعة المختارة
  int currentMonthIndex = DateTime.now().month - 1; // الشهر الحالي

  final List<String> hours = [
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
  ]; // قائمة الساعات

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      "january".tr(context),
      "february".tr(context),
      "march".tr(context),
      "april".tr(context),
      "may".tr(context),
      "june".tr(context),
      "july".tr(context),
      "august".tr(context),
      "september".tr(context),
      "october".tr(context),
      "november".tr(context),
      "december".tr(context),
    ];

    final List<String> days = [
      "7\n${"sunday".tr(context)}",
      "8\n${"monday".tr(context)}",
      "9\n${"tuesday".tr(context)}",
      "10\n${"wednesday".tr(context)}",
      "11\n${"thursday".tr(context)}",
    ];
// قائمة الأيام

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section: Available Days
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available Days",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (currentMonthIndex > 0) currentMonthIndex--;
                    });
                  },
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  months[currentMonthIndex],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (currentMonthIndex < 11) currentMonthIndex++;
                    });
                  },
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final isSelected = selectedDayIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDayIndex = index;
                  });
                },
                child: Container(
                  width: 70.w,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Color(0xffFFE2EC),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      days[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isSelected ? Colors.white : Color(0xff525252),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),

        // Section: Hours
        Text(
          "Hours",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // عدد الأعمدة
            mainAxisSpacing: 10.h, // المسافة الرأسية بين العناصر
            crossAxisSpacing: 10.w, // المسافة الأفقية بين العناصر
            childAspectRatio: 2.5, // نسبة العرض إلى الارتفاع
          ),
          itemCount: hours.length,
          itemBuilder: (context, index) {
            final isSelected = selectedHourIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedHourIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade300,
                    width: 1.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    hours[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
