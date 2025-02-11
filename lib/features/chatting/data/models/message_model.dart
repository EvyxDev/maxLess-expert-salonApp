import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/chatting/data/models/receiver_model.dart';
import 'package:maxless/features/chatting/data/models/sender_model.dart';

import 'reply_model.dart';

class MessageModel {
  final int? id;
  final String? message, createdAt;
  final SenderModel sender;
  final ReceiverModel receiver;
  final ReplyModel? reply;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.sender,
    required this.receiver,
    required this.reply,
  });

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      id: map[ApiKey.id],
      message: map[ApiKey.message],
      createdAt: map[ApiKey.createdAt],
      sender: SenderModel.fromJson(map[ApiKey.sender]),
      receiver: ReceiverModel.fromJson(map[ApiKey.receiver]),
      reply: map[ApiKey.reply] != null
          ? ReplyModel.fromJson(map[ApiKey.reply])
          : null,
    );
  }
}
