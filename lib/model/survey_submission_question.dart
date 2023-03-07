import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kayla_flutter_ic/model/survey_submission_answer.dart';

part 'survey_submission_question.g.dart';

@JsonSerializable()
class SurveySubmissionQuestion {
  final String id;
  final List<SurveySubmissionAnswer> answers;

  SurveySubmissionQuestion({
    required this.id,
    required this.answers,
  });

  Map<String, dynamic> toJson() => _$SurveySubmissionQuestionToJson(this);
}
