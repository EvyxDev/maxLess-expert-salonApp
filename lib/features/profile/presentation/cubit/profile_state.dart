part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class GetProfileLoadingState extends ProfileState {}

final class GetProfileErrorState extends ProfileState {
  final String message;

  const GetProfileErrorState({required this.message});
}

final class GetProfileSuccessState extends ProfileState {}

final class LikeProfileCommunityLoadingState extends ProfileState {}

final class LikeProfileCommunityErrorState extends ProfileState {
  final String message;

  const LikeProfileCommunityErrorState({required this.message});
}

final class LikeProfileCommunitySuccessState extends ProfileState {
  final String message;

  const LikeProfileCommunitySuccessState({required this.message});
}

final class GetReviewsLoadingState extends ProfileState {}

final class GetReviewsErrorState extends ProfileState {
  final String message;

  const GetReviewsErrorState({required this.message});
}

final class GetReviewsSuccessState extends ProfileState {}
