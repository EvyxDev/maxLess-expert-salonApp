import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/auth/data/models/slot_model.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/home/data/models/answer_and_question_model.dart';

class BookingItemModel {
  final int? id, orderId, status;
  final UserModel? user, expert;
  final SlotModel? expertSlot;
  final String? date, time, createdAt, updatedAt, code;
  final List<AnswerAndQuestionModel> answersAndQuestions;
  final double? lat, lon;

  BookingItemModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.user,
    required this.expert,
    required this.expertSlot,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.answersAndQuestions,
    required this.lat,
    required this.lon,
    required this.code,
    required this.time,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> map) {
    return BookingItemModel(
      id: map[ApiKey.id],
      orderId: map[ApiKey.orderId],
      status: map[ApiKey.status],
      user: UserModel.fromJson(map[ApiKey.user]),
      expert: map[ApiKey.expert] != null
          ? UserModel.fromJson(map[ApiKey.expert])
          : null,
      expertSlot: map[ApiKey.expertSlot] != null
          ? SlotModel.fromJson(map[ApiKey.expertSlot])
          : null,
      date: map[ApiKey.date],
      createdAt: map[ApiKey.createdAt],
      updatedAt: map[ApiKey.updatedAt],
      lat: map[ApiKey.lat],
      lon: map[ApiKey.lon],
      answersAndQuestions: map[ApiKey.answerAndQuestion] != null
          ? (map[ApiKey.answerAndQuestion] as List)
              .map((e) => AnswerAndQuestionModel.fromJson(e))
              .toList()
          : [],
      code: map[ApiKey.code],
      time: map[ApiKey.time],
    );
  }
}
