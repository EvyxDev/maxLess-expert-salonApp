part of 'logout_cubit.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

final class LogoutInitial extends LogoutState {}

final class LogoutLoadingState extends LogoutState {}

final class LogoutErrorState extends LogoutState {
  final String message;

  const LogoutErrorState({required this.message});
}

final class LogoutSuccessState extends LogoutState {
  final String message;

  const LogoutSuccessState({required this.message});
}
