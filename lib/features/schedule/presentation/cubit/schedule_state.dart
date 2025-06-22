part of 'schedule_cubit.dart';

sealed class ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

final class ScheduleLoaded extends ScheduleState {
  final String? message;

  ScheduleLoaded(this.message);
}

final class ScheduleError extends ScheduleState {
  final String error;

  ScheduleError(this.error);
}
final class GetAvailabilityByDateError extends ScheduleState {
  final String error;

  GetAvailabilityByDateError(this.error);
}

final class ScheduleInitial extends ScheduleState {}

final class SelectMonthState extends ScheduleState {}

final class ShadowToggleState extends ScheduleState {}

final class GetUnAvilableDaysLoading extends ScheduleState {}

final class GetUnAvilableDaysSuccess extends ScheduleState {}

final class GetUnAvilableDaysFailure extends ScheduleState {
  final String error;

  GetUnAvilableDaysFailure(this.error);
}
