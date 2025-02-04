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
