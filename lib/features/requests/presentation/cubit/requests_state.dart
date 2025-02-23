part of 'requests_cubit.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object> get props => [];
}

final class RequestsInitial extends RequestsState {}

final class GetRequestsLoadingState extends RequestsState {}

final class GetRequestsErrorState extends RequestsState {
  final String message;

  const GetRequestsErrorState({required this.message});
}

final class GetRequestsSuccessState extends RequestsState {}

final class BookingChangeStatusLoadingState extends RequestsState {}

final class BookingChangeStatusErrorState extends RequestsState {
  final String message;

  const BookingChangeStatusErrorState({required this.message});
}

final class BookingChangeStatusSuccessState extends RequestsState {
  final String message;

  const BookingChangeStatusSuccessState({required this.message});
}

final class CancelReasonLoadingState extends RequestsState {}

final class CancelReasonErrorState extends RequestsState {
  final String message;

  const CancelReasonErrorState({required this.message});
}

final class CancelReasonSuccessState extends RequestsState {
  final String message;

  const CancelReasonSuccessState({required this.message});
}
