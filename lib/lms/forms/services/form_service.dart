import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/form_model.dart';
import '../models/submission_model.dart';

class FormService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or Update Form
  Future<void> saveForm(FormModel form) async {
    final formCollection = _db.collection('forms');
    if (form.id.isEmpty) {
      // New form
      await formCollection.add(form.toFirestore());
    } else {
      // Update existing form
      await formCollection.doc(form.id).update(form.toFirestore());
    }
  }

  // Get Form by ID
  Future<FormModel?> getForm(String formId) async {
    final doc = await _db.collection('forms').doc(formId).get();
    if (doc.exists) {
      return FormModel.fromFirestore(doc);
    }
    return null;
  }

  // Get Forms for a specific Class (Student View)
  Future<List<FormModel>> getFormsForClass(String classId) async {
    final query = await _db
        .collection('forms')
        .where('classId', isEqualTo: classId)
        .where('isPublished', isEqualTo: true) // Only published for students
        .get();

    return query.docs.map((d) => FormModel.fromFirestore(d)).toList();
  }

  // Get Forms created by Teacher (Teacher View)
  Future<List<FormModel>> getFormsByTeacher(String teacherId) async {
    final query = await _db
        .collection('forms')
        .where('createdBy', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((d) => FormModel.fromFirestore(d)).toList();
  }

  // Submit Form (Student)
  Future<void> submitForm(SubmissionModel submission) async {
    await _db.collection('submissions').add(submission.toFirestore());
  }

  // Check if Student already submitted
  Future<bool> hasStudentSubmitted(String formId, String studentId) async {
    final query = await _db
        .collection('submissions')
        .where('formId', isEqualTo: formId)
        .where('studentId', isEqualTo: studentId)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }
}
