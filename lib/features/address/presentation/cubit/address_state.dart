part of 'address_cubit.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

final class AddressInitial extends AddressState {}

final class SetAddressLoadingState extends AddressState {}

final class SetAddressErrorState extends AddressState {
  final String messgae;

  const SetAddressErrorState({required this.messgae});
}

final class SetAddressSuccessState extends AddressState {}

final class SelectLocationManuallyState extends AddressState {}

final class GetCurrentLocationLoadingState extends AddressState {}

final class GetCurrentLocationSuccessState extends AddressState {}

final class GetCurrentLocationErrorState extends AddressState {
  final String error;

  const GetCurrentLocationErrorState({required this.error});
}
