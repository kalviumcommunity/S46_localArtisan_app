import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile(AppUser user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
