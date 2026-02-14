import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_builder_provider.dart';
import '../models/question_model.dart'; // For loop
import '../models/form_model.dart'; // For FormType
import '../widgets/question_card.dart';

class FormBuilderScreen extends StatelessWidget {
  final String? formId;
  final String userId;

  const FormBuilderScreen({Key? key, this.formId, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormBuilderProvider>(
      create: (_) => FormBuilderProvider()..initForm(formId, userId),
      child: const _FormBuilderContent(),
    );
  }
}

class _FormBuilderContent extends StatelessWidget {
  const _FormBuilderContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormBuilderProvider>(context);
    final form = provider.currentForm;

    if (provider.isLoading || form == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context, provider),
          ),
          TextButton(
            onPressed: () async {
              await provider.saveForm();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Draft Saved')));
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.send), // Publish
            onPressed: () async {
              await provider.publishForm();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Form Published!')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.only(bottom: 80),
        header: _buildHeader(context, provider, form),
        onReorder: (oldIndex, newIndex) {
          // Adjust index because of header? No, ReorderableListView.builder might be better if header is complex.
          // But here we can use children argument list.
          // Wait, ReorderableListView takes `children` or `builder`. Using `children` with header as first element is tricky for reordering indices.
          // Better: Use `SliverReorderableList` or just put header in `SingleChildScrollView` above list?
          // ReorderableListView has `header` property in recent Flutter versions.
          // But reorder indices apply to the list items only.
          provider.reorderQuestions(oldIndex, newIndex);
        },
        children: [
          for (int i = 0; i < form.questions.length; i++)
            QuestionCard(
              key: ValueKey(form.questions[i].id),
              question: form.questions[i],
              index: i,
              onUpdate: (q) => provider.updateQuestion(q.id, q),
              onDelete: (id) => provider.deleteQuestion(id),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddQuestionSheet(context, provider),
        label: const Text('Add Question'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    FormBuilderProvider provider,
    FormModel form,
  ) {
    // We wrap header in a Container that is NOT reorderable.
    // ReorderableListView `header` property handles this.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: form.title, // Can use controller if needed
                decoration: const InputDecoration(
                  labelText: 'Form Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (val) => provider.updateMetadata(title: val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: form.description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 2,
                onChanged: (val) => provider.updateMetadata(description: val),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Marks: ${form.totalMarks}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<FormType>(
                    value: form.type,
                    items: FormType.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString().split('.').last.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) provider.updateMetadata(type: val);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddQuestionSheet(
    BuildContext context,
    FormBuilderProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Question Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: QuestionType.values.map((type) {
                return ActionChip(
                  label: Text(
                    type
                        .toString()
                        .split('.')
                        .last
                        .replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' '),
                  ), // nice formatting
                  onPressed: () {
                    provider.addQuestion(type);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, FormBuilderProvider provider) {
    final form = provider.currentForm!;
    final timeController = TextEditingController(
      text: form.timeLimit?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Form Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<FormType>(
              value: form.type,
              decoration: const InputDecoration(labelText: 'Form Type'),
              items: FormType.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString().split('.').last.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) provider.updateMetadata(type: val);
              },
            ),
            const SizedBox(height: 16),
            if (form.type == FormType.test)
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time Limit (minutes)',
                  helperText: 'Leave empty for no limit',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  // Defer update or handle here.
                  // Ideally update provider on closing or valid input.
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              int? limit = int.tryParse(timeController.text);
              provider.updateMetadata(timeLimit: limit);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
