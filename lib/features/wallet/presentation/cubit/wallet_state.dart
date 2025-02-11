part of 'wallet_cubit.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletState {}

final class GetWalletLoadingState extends WalletState {}

final class GetWalletErrorState extends WalletState {
  final String message;

  const GetWalletErrorState({required this.message});
}

final class GetWalletSuccessState extends WalletState {}
