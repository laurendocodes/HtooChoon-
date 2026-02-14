import 'package:cloud_firestore/cloud_firestore.dart';

class SubmissionModel {
  String id;
  String formId;
  String studentId;
  Map<String, dynamic> answers; // Key: questionId, Value: answer
  int score;
  DateTime submittedAt;

  SubmissionModel({
    required this.id,
    required this.formId,
    required this.studentId,
    required this.answers,
    this.score = 0,
    required this.submittedAt,
  });

  factory SubmissionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SubmissionModel(
      id: doc.id,
      formId: data['formId'] ?? '',
      studentId: data['studentId'] ?? '',
      answers: Map<String, dynamic>.from(data['answers'] ?? {}),
      score: data['score'] ?? 0,
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'formId': formId,
      'studentId': studentId,
      'answers': answers,
      'score': score,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }
}
