import 'package:flutter/material.dart';
import '../models/question_model.dart';
import 'package:flutter/services.dart';

class QuestionCard extends StatefulWidget {
  final QuestionModel question;
  final Function(QuestionModel) onUpdate;
  final Function(String) onDelete;
  final int index;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onUpdate,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late TextEditingController _questionTextController;
  late TextEditingController _marksController;
  final Map<int, TextEditingController> _optionControllers = {};
  late TextEditingController _correctAnswerTextController;

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.question.questionText);
    _marksController = TextEditingController(text: widget.question.marks.toString());
    _correctAnswerTextController = TextEditingController(
        text: widget.question.correctAnswer is String ? widget.question.correctAnswer : '');
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _questionTextController.text = widget.question.questionText;
      _marksController.text = widget.question.marks.toString();
      _correctAnswerTextController.text =
          widget.question.correctAnswer is String ? widget.question.correctAnswer : '';
      _optionControllers.clear();
    } else {
        // If ID matches, we still might need to sync if external update happened
        if (widget.question.questionText != _questionTextController.text) {
             // Only update if cursor isn't active? No, simple sync for now.
             // _questionTextController.text = widget.question.questionText;
        }
    }
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _marksController.dispose();
    _correctAnswerTextController.dispose();
    for (var c in _optionControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getOptionController(int index, String text) {
    if (!_optionControllers.containsKey(index)) {
      _optionControllers[index] = TextEditingController(text: text);
    } 
    // We don't forcefully sync text here on every build to avoid cursor jumping, 
    // relying on the controller to hold state.
    // However, if options are reordered, this map might need invalidation.
    // Ideally we key options by value or ID, but they are just strings.
    return _optionControllers[index]!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionTextController,
                    decoration: const InputDecoration(
                      hintText: 'Question Text',
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) {
                      widget.onUpdate(widget.question.copyWith(questionText: val));
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDelete(widget.question.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTypeSelector(),
            const SizedBox(height: 12),
            _buildOptionsEditor(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Marks: '),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _marksController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          widget.onUpdate(widget.question.copyWith(marks: int.tryParse(val) ?? 0));
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Required: '),
                    Switch(
                      value: widget.question.required,
                      onChanged: (val) {
                        widget.onUpdate(widget.question.copyWith(required: val));
                      },
                    ),
                  ],
                ),
              ],
            ),
             // Answer Key section
            if (widget.question.type == QuestionType.multipleChoice || 
                widget.question.type == QuestionType.trueFalse || 
                widget.question.type == QuestionType.shortAnswer)
              _buildAnswerKeyConfig(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButton<QuestionType>(
      value: widget.question.type,
      isExpanded: true,
      onChanged: (QuestionType? newValue) {
        if (newValue != null) {
          widget.onUpdate(widget.question.copyWith(type: newValue));
        }
      },
      items: QuestionType.values.map<DropdownMenuItem<QuestionType>>((QuestionType value) {
        return DropdownMenuItem<QuestionType>(
          value: value,
          child: Text(value.toString().split('.').last.toUpperCase().replaceAll('_', ' ')),
        );
      }).toList(),
    );
  }

  Widget _buildOptionsEditor() {
    if (widget.question.type == QuestionType.shortAnswer || widget.question.type == QuestionType.paragraph) {
      return Text(
        'User will type answer here.',
        style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
      );
    }

    if (widget.question.type == QuestionType.multipleChoice || widget.question.type == QuestionType.checkbox) {
       return Column(
        children: [
          ...widget.question.options.asMap().entries.map((entry) {
            int idx = entry.key;
            String optionText = entry.value;
            final controller = _getOptionController(idx, optionText);
            
            return Row(
              children: [
                Icon(widget.question.type == QuestionType.multipleChoice 
                  ? Icons.radio_button_unchecked 
                  : Icons.check_box_outline_blank, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Option ${idx + 1}',
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      List<String> newOptions = List.from(widget.question.options);
                      newOptions[idx] = val;
                      widget.onUpdate(widget.question.copyWith(options: newOptions));
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    List<String> newOptions = List.from(widget.question.options);
                    newOptions.removeAt(idx);
                    widget.onUpdate(widget.question.copyWith(options: newOptions));
                    _optionControllers.clear(); // Reset controllers to avoid index mismatch
                  },
                ),
              ],
            );
          }).toList(),
          TextButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Option'),
            onPressed: () {
              List<String> newOptions = List.from(widget.question.options);
              newOptions.add('Option ${newOptions.length + 1}');
              widget.onUpdate(widget.question.copyWith(options: newOptions));
            },
          ),
        ],
      );
    }
    
    if (widget.question.type == QuestionType.trueFalse) {
        // Ensure options are correct for TF
      if (widget.question.options.isEmpty || widget.question.options.length != 2) {
          // This should be handled by provider ideally, but here for safety
      }
      return const Text('True / False options are fixed.');
    }

    return const SizedBox.shrink();
  }

  Widget _buildAnswerKeyConfig() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Answer Key', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          if (widget.question.type == QuestionType.shortAnswer)
            TextField(
              controller: _correctAnswerTextController,
              decoration: const InputDecoration(
                hintText: 'Correct Answer Text (Exact Match)',
                isDense: true,
              ),
              onChanged: (val) {
                widget.onUpdate(widget.question.copyWith(correctAnswer: val));
              },
            ),
           if (widget.question.type == QuestionType.multipleChoice || widget.question.type == QuestionType.trueFalse)
             DropdownButton<String>(
               value: _getValidDropdownValue(),
               hint: const Text('Select Correct Answer'),
               isExpanded: true,
               items: (widget.question.type == QuestionType.trueFalse 
                   ? ['True', 'False'] // Fixed options for TF
                   : widget.question.options).map((opt) {
                 return DropdownMenuItem(value: opt, child: Text(opt));
               }).toList(),
               onChanged: (val) {
                 widget.onUpdate(widget.question.copyWith(correctAnswer: val));
               },
             ),
        ],
      ),
    );
  }

  String? _getValidDropdownValue() {
      final validOptions = (widget.question.type == QuestionType.trueFalse) 
        ? ['True', 'False'] 
        : widget.question.options;
      
    if (widget.question.correctAnswer is String && validOptions.contains(widget.question.correctAnswer)) {
      return widget.question.correctAnswer;
    }
    return null;
  }
}
