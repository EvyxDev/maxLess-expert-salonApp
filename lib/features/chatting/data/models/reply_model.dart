import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/chatting/data/models/receiver_model.dart';
import 'package:maxless/features/chatting/data/models/sender_model.dart';

class ReplyModel {
  final int? id;
  final String? message, createdAt;
  final SenderModel? sender;
  final ReceiverModel? receiver;

  ReplyModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.sender,
    required this.receiver,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> map) {
    return ReplyModel(
      id: map[ApiKey.id],
      message: map[ApiKey.message] ?? map["msg"],
      createdAt: map[ApiKey.createdAt],
      sender: map[ApiKey.sender] != null
          ? SenderModel.fromJson(map[ApiKey.sender])
          : null,
      receiver: map[ApiKey.receiver] != null
          ? ReceiverModel.fromJson(map[ApiKey.receiver])
          : null,
    );
  }
}
