import 'package:flutter/material.dart';

class AssignmentWritingScreen extends StatefulWidget {
  final String assignmentId;
  const AssignmentWritingScreen({super.key, required this.assignmentId});

  @override
  State<AssignmentWritingScreen> createState() =>
      _AssignmentWritingScreenState();
}

class _AssignmentWritingScreenState extends State<AssignmentWritingScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  void _autoSave() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isSaving = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Submission'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                // Submit logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Assignment Submitted!")),
                );
              },
              child: const Text('Submit'),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.format_bold), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.format_italic),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted),
                  onPressed: () {},
                ),
                const Spacer(), // Spacer to push remaining icons to right if needed
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your answer here...',
                ),
                onChanged: (val) => _autoSave(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
