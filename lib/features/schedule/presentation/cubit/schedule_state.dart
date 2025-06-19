part of 'schedule_cubit.dart';

sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class SelectMonthState extends ScheduleState {}

final class ShadowToggleState extends ScheduleState {}

final class GetUnAvilableDaysLoading extends ScheduleState {}

final class GetUnAvilableDaysSuccess extends ScheduleState {}

final class GetUnAvilableDaysFailure extends ScheduleState {
  final String error;

  GetUnAvilableDaysFailure(this.error);
}
