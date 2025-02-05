import 'package:maxless/core/database/api/end_points.dart';
import 'package:maxless/features/auth/data/models/slot_model.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/home/data/models/answer_and_question_model.dart';

class BookingItemModel {
  final int? id, orderId, status;
  final UserModel? user, expert;
  final SlotModel? expertSlot;
  final String? date, createdAt, updatedAt;
  final List<AnswerAndQuestionModel> answersAndQuestions;

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
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> map) {
    return BookingItemModel(
      id: map[ApiKey.id],
      orderId: map[ApiKey.orderId],
      status: map[ApiKey.status],
      user: UserModel.fromJson(map[ApiKey.user]),
      expert: UserModel.fromJson(map[ApiKey.expert]),
      expertSlot: SlotModel.fromJson(map[ApiKey.expertSlot]),
      date: map[ApiKey.date],
      createdAt: map[ApiKey.createdAt],
      updatedAt: map[ApiKey.updatedAt],
      answersAndQuestions: map[ApiKey.answerAndQuestion] != null
          ? (map[ApiKey.answerAndQuestion] as List)
              .map((e) => AnswerAndQuestionModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
