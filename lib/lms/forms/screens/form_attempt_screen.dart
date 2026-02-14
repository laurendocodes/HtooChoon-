import 'dart:async';
import 'package:flutter/material.dart';
import '../models/form_model.dart';
import '../models/question_model.dart';
import '../models/submission_model.dart';
import '../services/form_service.dart';

class FormAttemptScreen extends StatefulWidget {
  final String formId;
  final String studentId;
  final String studentName;

  const FormAttemptScreen({
    Key? key,
    required this.formId,
    required this.studentId,
    required this.studentName,
  }) : super(key: key);

  @override
  State<FormAttemptScreen> createState() => _FormAttemptScreenState();
}

class _FormAttemptScreenState extends State<FormAttemptScreen> {
  final FormService _formService = FormService();
  final ValueNotifier<int> _timeRemainingNotifier = ValueNotifier<int>(0);

  FormModel? _form;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _hasSubmitted = false;

  final Map<String, dynamic> _answers = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeRemainingNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadForm() async {
    try {
      final form = await _formService.getForm(widget.formId);
      if (form != null) {
        final submitted = await _formService.hasStudentSubmitted(
          widget.formId,
          widget.studentId,
        );
        if (submitted) {
          if (mounted) {
            setState(() {
              _form = form;
              _hasSubmitted = true;
              _isLoading = false;
            });
          }
          return;
        }

        if (mounted) {
          setState(() {
            _form = form;
            _isLoading = false;

            for (var q in form.questions) {
              if (q.type == QuestionType.checkbox) {
                _answers[q.id] = <String>[];
              } else {
                _answers[q.id] = '';
              }
            }
          });
        }

        if (form.timeLimit != null && form.timeLimit! > 0) {
          _timeRemainingNotifier.value = form.timeLimit! * 60;
          _startTimer();
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemainingNotifier.value > 0) {
        _timeRemainingNotifier.value -= 1;
      } else {
        _timer?.cancel();
        _submitForm(autoSubmit: true);
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _submitForm({bool autoSubmit = false}) async {
    if (_isSubmitting || _hasSubmitted) return;

    if (!autoSubmit) {
      // Validate
      for (var q in _form!.questions) {
        if (q.required) {
          final ans = _answers[q.id];
          if (ans == null ||
              (ans is String && ans.isEmpty) ||
              (ans is List && ans.isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please answer required question: ${q.questionText}',
                ),
              ),
            );
            return;
          }
        }
      }
    }

    setState(() => _isSubmitting = true);

    int score = 0;
    for (var q in _form!.questions) {
      final ans = _answers[q.id];
      // Simple exact match logic
      if (q.correctAnswer != null &&
          ans.toString() == q.correctAnswer.toString()) {
        score += q.marks;
      }
    }

    final submission = SubmissionModel(
      id: '',
      formId: _form!.id,
      studentId: widget.studentId,
      answers: _answers,
      score: score,
      submittedAt: DateTime.now(),
    );

    await _formService.submitForm(submission);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _hasSubmitted = true;
      });
    }

    if (autoSubmit) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Time Up!'),
            content: const Text('Your exam has been submitted automatically.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Submission Successful!')));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_form == null)
      return const Scaffold(body: Center(child: Text('Form not found')));
    if (_hasSubmitted)
      return const Scaffold(
        body: Center(child: Text('You have already submitted this form.')),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(_form!.title),
        bottom: _form!.timeLimit != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: ValueListenableBuilder<int>(
                  valueListenable: _timeRemainingNotifier,
                  builder: (context, val, child) {
                    return Container(
                      color: val < 60 ? Colors.red[100] : Colors.blue[100],
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: Text(
                        'Time Remaining: ${_formatTime(val)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: val < 60 ? Colors.red : Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
              )
            : null,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _form!.questions.length + 1,
        itemBuilder: (context, index) {
          if (index == _form!.questions.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitForm(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            );
          }

          final question = _form!.questions[index];
          return QuestionAttemptItem(
            key: ValueKey(question.id),
            question: question,
            initialAnswer: _answers[question.id],
            onAnswerChanged: (val) {
              _answers[question.id] = val;
            },
          );
        },
      ),
    );
  }
}

class QuestionAttemptItem extends StatefulWidget {
  final QuestionModel question;
  final dynamic initialAnswer;
  final Function(dynamic) onAnswerChanged;

  const QuestionAttemptItem({
    Key? key,
    required this.question,
    this.initialAnswer,
    required this.onAnswerChanged,
  }) : super(key: key);

  @override
  State<QuestionAttemptItem> createState() => _QuestionAttemptItemState();
}

class _QuestionAttemptItemState extends State<QuestionAttemptItem> {
  late TextEditingController _textController;
  List<String> _selectedOptions = [];
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    if (widget.initialAnswer != null) {
      if (widget.question.type == QuestionType.shortAnswer ||
          widget.question.type == QuestionType.paragraph) {
        _textController.text = widget.initialAnswer.toString();
      } else if (widget.question.type == QuestionType.multipleChoice ||
          widget.question.type == QuestionType.trueFalse) {
        _selectedOption = widget.initialAnswer.toString();
      } else if (widget.question.type == QuestionType.checkbox &&
          widget.initialAnswer is List) {
        _selectedOptions = List<String>.from(widget.initialAnswer);
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: widget.question.questionText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  if (widget.question.required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Marks: ${widget.question.marks}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    if (widget.question.type == QuestionType.shortAnswer ||
        widget.question.type == QuestionType.paragraph) {
      return TextField(
        controller: _textController,
        maxLines: widget.question.type == QuestionType.paragraph ? 4 : 1,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Your answer',
        ),
        onChanged: (val) => widget.onAnswerChanged(val),
      );
    }

    if (widget.question.type == QuestionType.multipleChoice ||
        widget.question.type == QuestionType.trueFalse) {
      final options = widget.question.type == QuestionType.trueFalse
          ? ['True', 'False']
          : widget.question.options;
      return Column(
        children: options.map((opt) {
          return RadioListTile<String>(
            title: Text(opt),
            value: opt,
            groupValue: _selectedOption,
            onChanged: (val) {
              setState(() {
                _selectedOption = val;
              });
              widget.onAnswerChanged(val);
            },
          );
        }).toList(),
      );
    }

    if (widget.question.type == QuestionType.checkbox) {
      return Column(
        children: widget.question.options.map((opt) {
          final isSelected = _selectedOptions.contains(opt);
          return CheckboxListTile(
            title: Text(opt),
            value: isSelected,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedOptions.add(opt);
                } else {
                  _selectedOptions.remove(opt);
                }
              });
              widget.onAnswerChanged(_selectedOptions);
            },
          );
        }).toList(),
      );
    }

    return const Text('Unsupported question type');
  }
}
