part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class GetNotificationsLoadingState extends NotificationsState {}

final class GetNotificationsErrorState extends NotificationsState {
  final String message;

  const GetNotificationsErrorState({required this.message});
}

final class GetNotificationsSuccessState extends NotificationsState {}
