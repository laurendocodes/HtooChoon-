import 'package:flutter/material.dart';

class AssignmentGradingScreen extends StatelessWidget {
  final String assignmentId;
  const AssignmentGradingScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    // Mock submissions
    final submissions = List.generate(
      5,
      (index) => {
        'id': 'sub_$index',
        'studentName': 'Student ${index + 1}',
        'submittedAt': 'Oct 12, 10:30 AM',
        'status': index % 2 == 0 ? 'Graded' : 'Pending',
        'grade': index % 2 == 0 ? '85/100' : null,
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Submissions')),
      body: ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          final sub = submissions[index];
          final isGraded = sub['status'] == 'Graded';

          return ListTile(
            leading: CircleAvatar(
              child: Text(sub['studentName'].toString()[0]),
            ),
            title: Text(sub['studentName'].toString()),
            subtitle: Text('Submitted: ${sub['submittedAt']}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isGraded ? sub['grade'].toString() : 'Needs Grading',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isGraded ? Colors.green : Colors.orange,
                  ),
                ),
                if (isGraded)
                  const Icon(Icons.check_circle, color: Colors.green, size: 14),
              ],
            ),
            onTap: () {
              // TODO: Open grading detail (view document + grade form)
              _showGradingDialog(context, sub['studentName'] ?? "null error");
            },
          );
        },
      ),
    );
  }

  void _showGradingDialog(BuildContext context, String studentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Grade $studentName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Grade (0-100)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Grade'),
          ),
        ],
      ),
    );
  }
}
