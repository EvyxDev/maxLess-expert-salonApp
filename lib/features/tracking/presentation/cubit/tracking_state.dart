part of 'tracking_cubit.dart';

sealed class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object> get props => [];
}

final class TrackingInitial extends TrackingState {}

final class GetCurrentLocationLoadingState extends TrackingState {}

final class GetCurrentLocationSuccessState extends TrackingState {}

final class GetRouteLoadingState extends TrackingState {}

final class GetRouteSuccessState extends TrackingState {}

final class ArrivedLocationLoadingState extends TrackingState {}

final class ArrivedLocationErrorState extends TrackingState {
  final String message;

  const ArrivedLocationErrorState({required this.message});
}

final class ArrivedLocationSuccessState extends TrackingState {
  final String message;

  const ArrivedLocationSuccessState({required this.message});
}

final class SendMessageState extends TrackingState {}

final class SendStartTrackingLoadingState extends TrackingState {}

final class SendStartTrackingErrorState extends TrackingState {
  final String message;

  const SendStartTrackingErrorState({required this.message});
}

final class SendStartTrackingSuccessState extends TrackingState {}
