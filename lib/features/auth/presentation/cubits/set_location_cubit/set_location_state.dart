part of 'set_location_cubit.dart';

sealed class SetLocationState extends Equatable {
  const SetLocationState();

  @override
  List<Object> get props => [];
}

final class SetLocationInitial extends SetLocationState {}

final class SetLocationLoadingState extends SetLocationState {}

final class SetLocationErrorState extends SetLocationState {
  final String message;

  const SetLocationErrorState({required this.message});
}

final class SetLocationSuccessState extends SetLocationState {
  final String message;

  const SetLocationSuccessState({required this.message});
}

final class SaveLocationLoadingState extends SetLocationState {}

final class SaveLocationSuccessState extends SetLocationState {}
