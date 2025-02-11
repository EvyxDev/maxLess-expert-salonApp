part of 'chatting_cubit.dart';

sealed class ChattingState extends Equatable {
  const ChattingState();

  @override
  List<Object> get props => [];
}

final class ChattingInitial extends ChattingState {}

final class GetChatHistoryLoadingState extends ChattingState {}

final class GetChatHistoryErrorState extends ChattingState {}

final class GetChatHistorySuccessState extends ChattingState {}

final class AddMessageState extends ChattingState {}

final class ClearMessageState extends ChattingState {}

final class PickImageState extends ChattingState {}
