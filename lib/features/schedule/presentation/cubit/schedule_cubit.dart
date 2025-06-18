import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleInitial());

  ScrollController daysScrollController = ScrollController();

  //! Month
  int currentMonth = DateTime.now().month;

  selectMonth(int index) {
    if (index == 1) {
      if (currentMonth == 12) return;
      currentMonth++;
      emit(SelectMonthState());
    } else {
      if (currentMonth == 1) return;
      currentMonth--;
      emit(SelectMonthState());
    }
    daysScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  int getDaysInMonth(int year, int month) {
    int nextMonth = month == 12 ? 1 : month + 1;
    int nextMonthYear = month == 12 ? year + 1 : year;
    return DateTime(nextMonthYear, nextMonth, 1)
        .subtract(const Duration(days: 1))
        .day;
  }

  String getDayAbbreviation({required DateTime date}) {
    String fullDay =
        DateFormat('EEEE', sl<CacheHelper>().getCachedLanguage()).format(date);
    return fullDay.substring(0, 3);
  }

  daysScrollListener() {
    daysScrollController.addListener(() {
      if ((daysScrollController.position.maxScrollExtent -
              daysScrollController.offset) ==
          0) {
        emit(ShadowToggleState());
      } else if ((daysScrollController.position.maxScrollExtent -
              daysScrollController.offset) >
          10) {
        emit(ShadowToggleState());
      }
    });
  }
}
