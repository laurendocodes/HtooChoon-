import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';
part 'user_model.g.dart';

@JsonSerializable()
class JoinClassRequest {
  final String classId;

  JoinClassRequest({required this.classId});

  // factory JoinClassRequest.fromJson(Map<String, dynamic> json) =>
  //     _$JoinClassRequestFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$JoinClassRequestToJson(this);
}

@JsonSerializable()
class SubmitRequest {
  final String content;
  final String assignmentId;
  final String testId;

  SubmitRequest({
    required this.content,
    required this.assignmentId,
    required this.testId,
  });

  // factory SubmitRequest.fromJson(Map<String, dynamic> json) =>
  //     _$SubmitRequestFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$SubmitRequestToJson(this);
}
