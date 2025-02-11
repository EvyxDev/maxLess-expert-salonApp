import 'package:maxless/core/database/api/end_points.dart';

class AnswerAndQuestionModel {
  final String question, answer;

  AnswerAndQuestionModel({
    required this.question,
    required this.answer,
  });

  factory AnswerAndQuestionModel.fromJson(Map<String, dynamic> map) {
    return AnswerAndQuestionModel(
      question: map[ApiKey.question],
      answer: map[ApiKey.answer],
    );
  }
}
