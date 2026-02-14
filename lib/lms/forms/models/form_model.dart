import 'package:cloud_firestore/cloud_firestore.dart';
import 'question_model.dart';
import 'package:uuid/uuid.dart';

enum FormType { assignment, test }

class FormModel {
  String id;
  String title;
  String description;
  FormType type;
  String createdBy;
  String classId;
  String courseId;
  List<QuestionModel> questions;
  int? timeLimit; // in minutes (for tests)
  int totalMarks;
  bool isPublished;
  DateTime createdAt;
  DateTime? updatedAt;

  FormModel({
    required this.id,
    required this.title,
    this.description = '',
    this.type = FormType.assignment,
    required this.createdBy,
    this.classId = '',
    this.courseId = '',
    this.questions = const [],
    this.timeLimit,
    this.totalMarks = 0,
    this.isPublished = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory FormModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FormModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: FormType.values.firstWhere(
          (e) => e.toString() == 'FormType.${data['type']}',
          orElse: () => FormType.assignment),
      createdBy: data['createdBy'] ?? '',
      classId: data['classId'] ?? '',
      courseId: data['courseId'] ?? '',
      questions: (data['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromJson(q))
              .toList() ??
          [],
      timeLimit: data['timeLimit'],
      totalMarks: data['totalMarks'] ?? 0,
      isPublished: data['isPublished'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'createdBy': createdBy,
      'classId': classId,
      'courseId': courseId,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
      'totalMarks': totalMarks,
      'isPublished': isPublished,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
