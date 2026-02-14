enum QuestionType {
  shortAnswer,
  paragraph,
  multipleChoice,
  checkbox,
  trueFalse,
  fillInBlank,
}

class QuestionModel {
  String id;
  QuestionType type;
  String questionText;
  List<String> options;
  dynamic correctAnswer; // specific to type (String for short, List for checkbox, etc)
  int marks;
  bool required;

  QuestionModel({
    required this.id,
    required this.type,
    this.questionText = '',
    this.options = const [],
    this.correctAnswer,
    this.marks = 1,
    this.required = false,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      type: QuestionType.values.firstWhere(
          (e) => e.toString() == 'QuestionType.${json['type']}',
          orElse: () => QuestionType.shortAnswer),
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'],
      marks: json['marks'] ?? 1,
      required: json['required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'marks': marks,
      'required': required,
    };
  }

  QuestionModel copyWith({
    String? id,
    QuestionType? type,
    String? questionText,
    List<String>? options,
    dynamic correctAnswer,
    int? marks,
    bool? required,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      marks: marks ?? this.marks,
      required: required ?? this.required,
    );
  }
}
