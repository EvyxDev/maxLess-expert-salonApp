part of 'otp_cubit.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitial extends OtpState {}

final class CheckOtpLoadingState extends OtpState {}

final class CheckOtpErrorState extends OtpState {
  final String message;

  const CheckOtpErrorState({required this.message});
}

final class CheckOtpSuccessState extends OtpState {}

final class ResendCodeLoadingState extends OtpState {}

final class ResendCodeErrorState extends OtpState {
  final String message;

  const ResendCodeErrorState({required this.message});
}

final class ResendCodeSuccessState extends OtpState {
  final String message;

  const ResendCodeSuccessState({required this.message});
}
