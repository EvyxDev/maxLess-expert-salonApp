class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class GetProfileLoadingState extends ProfileState {}

final class GetProfileErrorState extends ProfileState {
  final String message;

  GetProfileErrorState({required this.message});
}

final class GetProfileSuccessState extends ProfileState {
  final String? message;

  GetProfileSuccessState({this.message});
}

final class LikeProfileCommunityLoadingState extends ProfileState {}

final class LikeProfileCommunityErrorState extends ProfileState {
  final String message;

  LikeProfileCommunityErrorState({required this.message});
}

final class LikeProfileCommunitySuccessState extends ProfileState {
  final String message;

  LikeProfileCommunitySuccessState({required this.message});
}

final class GetReviewsLoadingState extends ProfileState {}

final class GetReviewsErrorState extends ProfileState {
  final String message;

  GetReviewsErrorState({required this.message});
}

final class GetReviewsSuccessState extends ProfileState {}

final class PickImageState extends ProfileState {}

final class UpdateProfileImageLoadingState extends ProfileState {}

final class UpdateProfileImageErrorState extends ProfileState {
  final String message;

  UpdateProfileImageErrorState({required this.message});
}

final class UpdateProfileImageSuccessState extends ProfileState {
  final String message;

  UpdateProfileImageSuccessState({required this.message});
}
