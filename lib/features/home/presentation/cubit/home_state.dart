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
