part of 'session_cubit.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

final class SessionInitial extends SessionState {}

final class StartSessionLoadingState extends SessionState {}

final class StartSessionErrorState extends SessionState {
  final String message;

  const StartSessionErrorState({required this.message});
}

final class StartSessionSuccessState extends SessionState {
  final String message;

  const StartSessionSuccessState({required this.message});
}

final class EndSessionLoadingState extends SessionState {}

final class EndSessionErrorState extends SessionState {
  final String message;

  const EndSessionErrorState({required this.message});
}

final class EndSessionSuccessState extends SessionState {
  final String message;

  const EndSessionSuccessState({required this.message});
}

final class TakePhotoLoadingState extends SessionState {}

final class TakePhotoErrorState extends SessionState {
  final String message;

  const TakePhotoErrorState({required this.message});
}

final class TakePhotoSuccessState extends SessionState {
  final String message;

  const TakePhotoSuccessState({required this.message});
}

final class ExpertSafeLoadingState extends SessionState {}

final class ExpertSafeErrorState extends SessionState {
  final String message;

  const ExpertSafeErrorState({required this.message});
}

final class ExpertSafeSuccessState extends SessionState {
  final String message;

  const ExpertSafeSuccessState({required this.message});
}

final class PickImageState extends SessionState {}

final class FeedbackLoadingState extends SessionState {}

final class FeedbackErrorState extends SessionState {
  final String message;

  const FeedbackErrorState({required this.message});
}

final class FeedbackSuccessState extends SessionState {
  final String message;

  const FeedbackSuccessState({required this.message});
}

final class UpdateFeedbackState extends SessionState {}

final class ScanQrCodeLoadingState extends SessionState {}

final class ScanQrCodeErrorState extends SessionState {
  final String message;

  const ScanQrCodeErrorState({required this.message});
}

final class ScanQrCodeSuccessState extends SessionState {
  final String message;

  const ScanQrCodeSuccessState({required this.message});
}

final class SetSessionPriceLoadingState extends SessionState {}

final class SetSessionPriceErrorState extends SessionState {
  final String message;

  const SetSessionPriceErrorState({required this.message});
}

final class SetSessionPriceSuccessState extends SessionState {
  final String message;

  const SetSessionPriceSuccessState({required this.message});
}

final class SessionReceiptLoadingState extends SessionState {}

final class SessionReceiptErrorState extends SessionState {
  final String message;

  const SessionReceiptErrorState({required this.message});
}

final class SessionReceiptSuccessState extends SessionState {}
