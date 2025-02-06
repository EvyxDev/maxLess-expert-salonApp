import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/wallet/data/models/transaction_model.dart';
import 'package:maxless/features/wallet/data/repository/wallet_repo.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  //! Get Expert Wallet
  String? totalBalance;
  List<TransactionModel> transactions = [];
  Future<void> getExpertWallet(BuildContext context) async {
    emit(GetWalletLoadingState());
    final result = await sl<WalletRepo>().getExpertWallet(
      expertId: context.read<GlobalCubit>().userId!,
    );
    result.fold(
      (l) => emit(GetWalletErrorState(message: l)),
      (r) {
        totalBalance = r.totalBalance;
        transactions = r.transactions;
        emit(GetWalletSuccessState());
      },
    );
  }
}
