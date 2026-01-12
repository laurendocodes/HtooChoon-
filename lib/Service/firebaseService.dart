import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('User not found');
    }
  }
}
