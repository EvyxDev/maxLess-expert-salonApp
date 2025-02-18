import 'package:maxless/core/database/api/end_points.dart';

class ReceiptBookingModel {
  final int? id, totalPrice;
  final String? date, startSession, endSession, phone, amount, discount;

  ReceiptBookingModel({
    required this.id,
    required this.amount,
    required this.discount,
    required this.date,
    required this.startSession,
    required this.endSession,
    required this.phone,
    required this.totalPrice,
  });

  factory ReceiptBookingModel.fromJson(Map<String, dynamic> map) {
    return ReceiptBookingModel(
      id: map[ApiKey.id],
      amount: map[ApiKey.amount],
      discount: map[ApiKey.discount],
      date: map[ApiKey.date],
      startSession: map[ApiKey.startSession],
      endSession: map[ApiKey.endSession],
      phone: map[ApiKey.phone],
      totalPrice: map[ApiKey.totalPrice],
    );
  }
}
