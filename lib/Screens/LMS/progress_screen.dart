import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Providers/progress_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<OrgProvider>().role;
    
    if (role == 'teacher' || role == 'owner') {
      return const _TeacherProgressView();
    } else {
      return const _StudentProgressView();
    }
  }
}

class _StudentProgressView extends StatelessWidget {
  const _StudentProgressView();

  @override
  Widget build(BuildContext context) {
    // In a real app, this would iterate over enrolled classes
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("My Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildProgressCard(context, "Advanced Mathematics", 0.75),
        _buildProgressCard(context, "History of Art", 0.40),
        _buildProgressCard(context, "Physics 101", 0.10),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, String className, double progress) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(className, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
             const SizedBox(height: 12),
             LinearProgressIndicator(
               value: progress,
               minHeight: 8,
               backgroundColor: Colors.grey[200],
               valueColor: AlwaysStoppedAnimation(
                 progress > 0.7 ? Colors.green : (progress > 0.3 ? Colors.orange : Colors.red)
               ),
               borderRadius: BorderRadius.circular(4),
             ),
             const SizedBox(height: 8),
             Align(
               alignment: Alignment.centerRight,
               child: Text("${(progress * 100).toInt()}% Complete", style: TextStyle(color: Colors.grey[600])),
             ),
          ],
        ),
      ),
    );
  }
}

class _TeacherProgressView extends StatefulWidget {
  const _TeacherProgressView();

  @override
  State<_TeacherProgressView> createState() => _TeacherProgressViewState();
}

class _TeacherProgressViewState extends State<_TeacherProgressView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mock class ID fetch
      context.read<ProgressProvider>().fetchClassProgress('class_1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Class Performance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...provider.studentProgressList.map((student) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text(student['studentName'][0])),
              title: Text(student['studentName']),
              subtitle: LinearProgressIndicator(value: student['progress']),
              trailing: Text("${(student['progress'] * 100).toInt()}%"),
            )),
          ],
        );
      },
    );
  }
}
