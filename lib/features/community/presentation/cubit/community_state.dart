part of 'community_cubit.dart';

sealed class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object> get props => [];
}

final class CommunityInitial extends CommunityState {}

final class GetCommunityLoadingState extends CommunityState {}

final class GetCommunityErrorState extends CommunityState {
  final String message;

  const GetCommunityErrorState({required this.message});
}

final class GetCommunitySuccessState extends CommunityState {}

final class LikeCommunityLoadingState extends CommunityState {}

final class LikeCommunityErrorState extends CommunityState {
  final String message;

  const LikeCommunityErrorState({required this.message});
}

final class LikeCommunitySuccessState extends CommunityState {
  final String message;

  const LikeCommunitySuccessState({required this.message});
}

final class DeleteCommunityLoadingState extends CommunityState {}

final class DeleteCommunityErrorState extends CommunityState {
  final String message;

  const DeleteCommunityErrorState({required this.message});
}

final class DeleteCommunitySuccessState extends CommunityState {
  final String message;

  const DeleteCommunitySuccessState({required this.message});
}

final class CreateCommunityLoadingState extends CommunityState {}

final class CreateCommunityErrorState extends CommunityState {
  final String message;

  const CreateCommunityErrorState({required this.message});
}

final class CreateCommunitySuccessState extends CommunityState {}

final class UpdateCommunityLoadingState extends CommunityState {}

final class UpdateCommunityErrorState extends CommunityState {
  final String message;

  const UpdateCommunityErrorState({required this.message});
}

final class UpdateCommunitySuccessState extends CommunityState {}

class PickImageState extends CommunityState {}
