import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/schedule/data/models/unavilable_day.dart';

import '../../data/models/availability_by_date_model/availability_by_date_model.dart';
import '../../data/models/availability_by_date_model/slot.dart';
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
    if (sl<CacheHelper>().getCachedLanguage() == 'en') {
      fullDay = fullDay.substring(0, 3);
    }

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

  String? selectedDay;
  selectDay(int index, {bool isloading = true}) async {
    final formattedDate = getDayFormatted(index);
    selectedDay = formattedDate;
    await getAvailabilityByDate(formattedDate, isLoading: isloading);
    log("Selected Day: $formattedDate");
    emit(ScheduleInitial());
  }

  isDayselected(int index) {
    if (selectedDay == null) return false;
    final String day = getDayFormatted(index);
    return selectedDay == day;
  }

  getDayFormatted(int index) {
    DateTime day = DateTime(DateTime.now().year, currentMonth, index + 1);
    return DateFormat('yyyy-MM-dd').format(day);
  }

  isDayAvilable(int index) {
    final String day = getDayFormatted(index);
    return !unAvailableDays.any((element) => element.exceptionDate == day);
  }

  List<TextEditingController> fromSlots = [];
  List<TextEditingController> toSlots = [];
  updateToSlot(index, value) {
    toSlots[index].text = value;
    emit(ScheduleInitial());
  }

  updateFromSlot(index, value) {
    fromSlots[index].text = value;
    emit(ScheduleInitial());
  }

  addNewSlot() {
    fromSlots.add(TextEditingController(text: '09:00'));
    toSlots.add(TextEditingController(text: '21:00'));
    emit(ScheduleInitial());
  }

  removeSlot(int index) {
    if (fromSlots.length > 1) {
      fromSlots.removeAt(index);
      toSlots.removeAt(index);
      emit(ScheduleInitial());
    }
  }

  List<UnavilableDay> unAvailableDays = [];
  getUnAvilableDays() async {
    emit(ScheduleLoading());
    final result = await repo.getUnAvilableDays();
    result.fold(
      (error) => emit(GetUnAvilableDaysFailure(error)),
      (unAvailableDaysList) async {
        unAvailableDays = unAvailableDaysList;
        await selectDay(0, isloading: false);
        emit(GetUnAvilableDaysSuccess());
      },
    );
  }

  markUnAvilableDay(String day) async {
    emit(ScheduleLoading());
    final result = await repo.markUnAvilableDay(day: day);
    result.fold(
      (error) => emit(ScheduleError(error)),
      (message) {
        unAvailableDays.add(UnavilableDay(exceptionDate: day));
        dayIsActive = false;
        emit(ScheduleLoaded(message));
      },
    );
  }

  markAvilableDay(String day) async {
    emit(ScheduleLoading());
    final result = await repo.markAvilableDay(day: day);
    result.fold(
      (error) => emit(ScheduleError(error)),
      (message) {
        unAvailableDays.removeWhere((e) => e.exceptionDate == day);
        dayIsActive = true;
        emit(ScheduleLoaded(message));
      },
    );
  }

  putExceptions() async {
    emit(ScheduleLoading());

    final newSlots = fromSlots
        .asMap()
        .entries
        .map((entry) => {
              'start': entry.value.text.trim(),
              'end': toSlots[entry.key].text.trim(),
            })
        .toList();

    final result = await repo.putExceptions(
      day: selectedDay ?? '',
      slots: newSlots,
    );

    result.fold(
      (error) => emit(ScheduleError(error)),
      (message) {
        availabilityByDateModel?.slots = newSlots
            .map((e) => Slot(
                  start: e['start'],
                  end: e['end'],
                ))
            .toList();

        emit(ScheduleLoaded(message));
      },
    );
  }

  AvailabilityByDateModel? availabilityByDateModel;
  bool? dayIsActive = true;
  updateDayIsActive(bool value) {
    dayIsActive = value;
    emit(ScheduleInitial());
  }

  getAvailabilityByDate(String day, {bool isLoading = true}) async {
    availabilityByDateModel = null;
    if (isLoading) emit(ScheduleLoading());
    final result = await repo.availabilityByDate(day: day);
    result.fold(
      (error) {
        if (isLoading) emit(GetAvailabilityByDateError(error));
      },
      (data) {
        availabilityByDateModel = data;
        dayIsActive = availabilityByDateModel?.isAvailable;
        fromSlots.clear();
        toSlots.clear();
        data.slots?.forEach((slot) {
          fromSlots.add(TextEditingController(text: slot.start ?? ''));
          toSlots.add(TextEditingController(text: slot.end ?? ''));
        });

        emit(ScheduleLoaded(null));
      },
    );
  }

  bool isAvailabilityChanged() {
    if (availabilityByDateModel == null) return false;

    // if (dayIsActive != availabilityByDateModel!.isAvailable) {
    //   return true;
    // }

    final originalSlots = availabilityByDateModel!.slots ?? [];

    if (originalSlots.length != fromSlots.length) {
      return true;
    }

    String normalizeTime(String time) {
      List<String> parts = time.split(':');
      String hour = parts[0].padLeft(2, '0');
      String minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
      return '$hour:$minute';
    }

    for (int i = 0; i < originalSlots.length; i++) {
      final originalStart = normalizeTime(originalSlots[i].start ?? '');
      final originalEnd = normalizeTime(originalSlots[i].end ?? '');
      final currentStart = normalizeTime(fromSlots[i].text.trim());
      final currentEnd = normalizeTime(toSlots[i].text.trim());

      if (originalStart != currentStart || originalEnd != currentEnd) {
        return true;
      }
    }

    return false;
  }
}
