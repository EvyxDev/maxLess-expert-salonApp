import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class HomeCalendar extends StatefulWidget {
  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime _currentDate = DateTime.now();
  int _selectedDay = DateTime.now().day;
  final ScrollController _scrollController = ScrollController();

  late List<String> days;
  late List<String> months;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // تحميل أسماء الأيام والأشهر بالترجمة.
    days = [
      "sun_day".tr(context),
      "mon_day".tr(context),
      "tue_day".tr(context),
      "wed_day".tr(context),
      "thu_day".tr(context),
      "fri_day".tr(context),
      "sat_day".tr(context),
    ];

    months = [
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
  }

  List<DateTime> _generateDaysInMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    return List<DateTime>.generate(
      lastDayOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + delta, 1);
      _selectedDay = -1; // لإلغاء تحديد اليوم عند تغيير الشهر.
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  void _scrollToSelectedDay() {
    final selectedIndex = _selectedDay - 1;
    if (selectedIndex >= 0) {
      final scrollPosition = selectedIndex * 75.w;
      _scrollController.animateTo(
        scrollPosition - MediaQuery.of(context).size.width / 2 + 37.5.w,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _generateDaysInMonth(_currentDate);
    final locale = Directionality.of(context) == TextDirection.rtl;

    return Column(
      children: [
        // عرض الشهور والأزرار
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: locale ? TextDirection.rtl : TextDirection.ltr,
          children: [
            GestureDetector(
              onTap: () => _changeMonth(-1),
              child: Row(
                children: [
                  Icon(
                      locale
                          ? CupertinoIcons.arrow_right
                          : CupertinoIcons.arrow_left,
                      size: 20.sp,
                      color: Color(0xff585A66)),
                  SizedBox(width: 8.w),
                  Text(
                    months[(_currentDate.month - 2 + 12) % 12],
                    style: TextStyle(
                      color: Color(0xff585A66),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              months[_currentDate.month - 1],
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            GestureDetector(
              onTap: () => _changeMonth(1),
              child: Row(
                children: [
                  Text(
                    months[_currentDate.month % 12],
                    style: TextStyle(
                      color: Color(0xff585A66),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                      locale
                          ? CupertinoIcons.arrow_left
                          : CupertinoIcons.arrow_right,
                      size: 20.sp,
                      color: Color(0xff585A66)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // عرض الأيام
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: daysInMonth.length,
            itemBuilder: (context, index) {
              final day = daysInMonth[index];
              final isSelected = _selectedDay == day.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day.day;
                  });
                  _scrollToSelectedDay();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 65.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Color(0xffFFE2EC),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${day.day}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Color(0xff585A66),
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        days[day.weekday % 7],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Color(0xff585A66),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
