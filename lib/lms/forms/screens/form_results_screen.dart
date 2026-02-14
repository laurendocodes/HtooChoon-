import 'package:flutter/material.dart';
import '../models/submission_model.dart';
import '../models/form_model.dart';

class FormResultsScreen extends StatelessWidget {
  final SubmissionModel submission;
  final FormModel form;

  const FormResultsScreen({Key? key, required this.submission, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result: ${form.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Total Score', style: TextStyle(fontSize: 18)),
                    Text(
                      '${submission.score} / ${form.totalMarks}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Answer Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...form.questions.map((q) {
              final studentAnswer = submission.answers[q.id];
              final isCorrect = q.correctAnswer != null && studentAnswer.toString() == q.correctAnswer.toString();
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: isCorrect ? Colors.green[50] : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.questionText, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Your Answer: $studentAnswer'),
                      if (!isCorrect && q.correctAnswer != null)
                        Text('Correct Answer: ${q.correctAnswer}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      if (q.correctAnswer == null)
                        const Text('Needs manual grading', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
