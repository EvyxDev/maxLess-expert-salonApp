import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';

import 'receipt_booking_model.dart';

class ReceiptDetailModel {
  final UserModel salon;
  final ReceiptBookingModel booking;

  ReceiptDetailModel({
    required this.salon,
    required this.booking,
  });

  factory ReceiptDetailModel.fromJson(Map<String, dynamic> map) {
    return ReceiptDetailModel(
      salon: UserModel.fromJson(map[ApiKey.expert]),
      booking: ReceiptBookingModel.fromJson(map[ApiKey.booking]),
    );
  }
}
