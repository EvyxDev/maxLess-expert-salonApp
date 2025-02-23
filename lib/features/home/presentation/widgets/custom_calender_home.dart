import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key});

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime _currentDate = DateTime.now();
  int _selectedDay = DateTime.now().day;
  late int year;
  final ScrollController _scrollController = ScrollController();
  final Map<int, ValueKey> itemKeys = {};

  late List<String> days;
  late List<String> months;

  @override
  void initState() {
    super.initState();
    year = _currentDate.year;
    Future.delayed(
      const Duration(seconds: 0),
      () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            (_currentDate.day - 1) * 120,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

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
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    return List<DateTime>.generate(
      lastDayOfMonth.day,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + delta, 1);
      _selectedDay = 1; // لإلغاء تحديد اليوم عند تغيير الشهر.
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  void _scrollToSelectedDay() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        (_selectedDay - 1) * 120,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _generateDaysInMonth(_currentDate);
    final locale = Directionality.of(context) == TextDirection.rtl;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Column(
          children: [
            //! Months
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: locale ? TextDirection.rtl : TextDirection.ltr,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_currentDate.month == 1) {
                      year--;
                    }
                    _changeMonth(-1);
                    cubit.getExpertBookingsByDate(
                      day: _currentDate.day,
                      month: _currentDate.month,
                      year: year,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                          locale
                              ? CupertinoIcons.arrow_right
                              : CupertinoIcons.arrow_left,
                          size: 20.sp,
                          color: const Color(0xff585A66)),
                      SizedBox(width: 8.w),
                      Text(
                        months[(_currentDate.month - 2 + 12) % 12],
                        style: TextStyle(
                          color: const Color(0xff585A66),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      months[_currentDate.month - 1],
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      year.toString(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (_currentDate.month == 12) {
                      year++;
                    }
                    _changeMonth(1);
                    cubit.getExpertBookingsByDate(
                      day: _currentDate.day,
                      month: _currentDate.month,
                      year: year,
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        months[_currentDate.month % 12],
                        style: TextStyle(
                          color: const Color(0xff585A66),
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
                          color: const Color(0xff585A66)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            //! Days
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: daysInMonth.length,
                itemBuilder: (context, index) {
                  final day = daysInMonth[index];
                  final isSelected = _selectedDay == day.day;
                  itemKeys[index] = ValueKey(index);
                  return GestureDetector(
                    key: ValueKey(index),
                    onTap: () {
                      setState(() {
                        _selectedDay = day.day;
                      });
                      _scrollToSelectedDay();
                      cubit.getExpertBookingsByDate(
                        day: day.day,
                        month: day.month,
                        year: year,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      width: 100.w,
                      height: 80.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0xffFFE2EC),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${day.day}",
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xff585A66),
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            days[day.weekday % 7],
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xff585A66),
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
      },
    );
  }
}
