import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/assignment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:htoochoon_flutter/Screens/LMS/assignment_detail_screen.dart';

class AssignmentListScreen extends StatefulWidget {
  final String classId;
  const AssignmentListScreen({super.key, required this.classId});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentProvider>().fetchAssignments(widget.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.assignments.isEmpty) {
          return const Center(child: Text("No assignments yet."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.assignments.length,
          itemBuilder: (context, index) {
            final assignment = provider.assignments[index];
            return _AssignmentCard(assignment: assignment);
          },
        );
      },
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final Map<String, dynamic> assignment;
  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final DateTime? dueDate = (assignment['dueDate'] as Timestamp?)?.toDate();
    final String formattedDate = dueDate != null
        ? DateFormat('MMM d, h:mm a').format(dueDate)
        : 'No due date';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.assignment, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          assignment['title'] ?? 'Untitled',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Due: $formattedDate'),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AssignmentDetailScreen(
                assignmentId: assignment['id'],
                title: assignment['title'] ?? 'Assignment',
              ),
            ),
          );
        },
      ),
    );
  }
}
