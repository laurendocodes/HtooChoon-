import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form_builder_screen.dart';
import 'form_attempt_screen.dart';
import '../models/form_model.dart';

class LmsHomeScreen extends StatefulWidget {
  final String userId;
  final String userRole;
  final String classId;

  const LmsHomeScreen({
    Key? key,
    required this.userId,
    required this.userRole,
    required this.classId,
  }) : super(key: key);

  @override
  State<LmsHomeScreen> createState() => _LmsHomeScreenState();
}

class _LmsHomeScreenState extends State<LmsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.userRole == 'teacher')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormBuilderScreen(userId: widget.userId),
                    ),
                  );
                },
              ),
            ),
          ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('forms')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return const Center(child: Text('No forms available.'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final form = FormModel.fromFirestore(docs[index]);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        form.type == FormType.test
                            ? Icons.timer
                            : Icons.assignment,
                      ),
                      title: Text(form.title),
                      subtitle: Text(
                        '${form.questions.length} Questions • ${form.totalMarks} Marks',
                      ),
                      trailing: widget.userRole == 'teacher'
                          ? IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FormBuilderScreen(
                                      formId: form.id,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: () {
                        if (widget.userRole == 'student') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormAttemptScreen(
                                formId: form.id,
                                studentId: widget.userId,
                                studentName: 'Student', // Mock name
                              ),
                            ),
                          );
                        } else {
                          // Teacher View Results or Preview
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormBuilderScreen(
                                formId: form.id,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
