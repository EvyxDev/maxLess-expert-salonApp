part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState({required this.message});
}

final class LoginSuccessState extends LoginState {
  final String message;

  const LoginSuccessState({required this.message});
}
