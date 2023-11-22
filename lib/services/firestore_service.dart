import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_social_auth/model/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserDataToFirestore(UserModel user) async {
    final DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

    await userDoc.set({
      'name': user.name,
      'email': user.email,
      'uid': user.uid,
      'image_url': user.imageUrl,
      'provider': user.provider,
    });
  }

  Future<UserModel?> getUserDataFromFirestore(String uid) async {
    final DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserModel.fromJson(data);
    }

    return null;
  }
}