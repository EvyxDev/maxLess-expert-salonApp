part of 'tracking_cubit.dart';

sealed class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object> get props => [];
}

final class TrackingInitial extends TrackingState {}

final class GetCurrentLocationLoadingState extends TrackingState {}

final class GetCurrentLocationSuccessState extends TrackingState {}

final class GetRouteSuccessState extends TrackingState {}
