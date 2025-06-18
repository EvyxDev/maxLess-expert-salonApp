part of 'schedule_cubit.dart';

sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class SelectMonthState extends ScheduleState {}

final class ShadowToggleState extends ScheduleState {}
