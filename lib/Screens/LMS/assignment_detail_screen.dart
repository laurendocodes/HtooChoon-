import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/LMS/assignment_writing_screen.dart';
import 'package:htoochoon_flutter/Screens/LMS/assignment_grading_screen.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final String assignmentId;
  final String title;

  const AssignmentDetailScreen({
    super.key,
    required this.assignmentId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final role = context.read<OrgProvider>().role;
    final isTeacher = role == 'owner' || role == 'teacher';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildInstructions(context),
            const SizedBox(height: 32),
            if (!isTeacher) _buildStudentAction(context),
            if (isTeacher) _buildTeacherAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              "Due: Coming soon",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.star_outline, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text("100 Points", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instructions",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "This is a placeholder for the assignment instructions. In a real app, this would be fetched from the AssignmentProvider.",
          style: TextStyle(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStudentAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => AssignmentWritingScreen(assignmentId: assignmentId),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text("Start / Edit Submission"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTeacherAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => AssignmentGradingScreen(assignmentId: assignmentId),
            ),
          );
        },
        icon: const Icon(Icons.grading),
        label: const Text("View Submissions & Grade"),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
