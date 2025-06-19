import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/schedule/data/models/unavilable_day.dart';

import '../../data/repository/schedule_repo.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleInitial());
  final ScheduleRepo repo = sl<ScheduleRepo>();
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
    return fullDay;
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

  List<UnavilableDay> unAvailableDays = [];
  getUnAvilableDays() async {
    emit(GetUnAvilableDaysLoading());
    final result = await repo.getUnAvilableDays();
    result.fold(
      (error) => emit(GetUnAvilableDaysFailure(error)),
      (unAvailableDaysList) {
        unAvailableDays = unAvailableDaysList;
        emit(GetUnAvilableDaysSuccess());
      },
    );
  }
}
