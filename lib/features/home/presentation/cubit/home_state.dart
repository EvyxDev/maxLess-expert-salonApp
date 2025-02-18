part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class GetBookingByDateLoadingState extends HomeState {}

final class GetBookingByDateErrorState extends HomeState {
  final String message;

  const GetBookingByDateErrorState({required this.message});
}

final class GetBookingByDateSuccessState extends HomeState {}

final class SessionLastStepLoadingState extends HomeState {}

final class SessionLastStepSuccessState extends HomeState {
  final String? message;

  const SessionLastStepSuccessState({required this.message});
}

final class SessionLastStepErrorState extends HomeState {
  final String message;

  const SessionLastStepErrorState({required this.message});
}

final class CheckSessionPriceLoadingState extends HomeState {}

final class CheckSessionPriceErrorState extends HomeState {
  final String message;

  const CheckSessionPriceErrorState({required this.message});
}

final class CheckSessionPriceSuccess extends HomeState {
  final bool result;

  const CheckSessionPriceSuccess({required this.result});
}
