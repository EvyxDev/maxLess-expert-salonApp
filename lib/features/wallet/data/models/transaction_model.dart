import 'package:maxless/core/database/api/end_points.dart';

class TransactionModel {
  final int id;
  final String title, body, amount, createdAt, updatedAt;

  TransactionModel({
    required this.id,
    required this.title,
    required this.body,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      id: map[ApiKey.id],
      title: map[ApiKey.title],
      body: map[ApiKey.body],
      amount: map[ApiKey.amount],
      createdAt: map[ApiKey.createdAt],
      updatedAt: map[ApiKey.updatedAt],
    );
  }
}
