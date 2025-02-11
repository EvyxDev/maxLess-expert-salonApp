import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/wallet/data/models/transaction_model.dart';

class WalletModel {
  final String? totalBalance;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.totalBalance,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> map) {
    return WalletModel(
      totalBalance: map[ApiKey.totalBalance],
      transactions: map[ApiKey.transactions] != null
          ? (map[ApiKey.transactions] as List)
              .map((e) => TransactionModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
