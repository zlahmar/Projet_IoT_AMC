//Gestion des interactions avec Firebase (auth, database)import 'package:firebase_auth/firebase_auth.dart';
/*import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.reference();

  Future<User?> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> saveMessage(String message, String userId) async {
    await _db.child("messages").push().set({
      "userId": userId,
      "message": message,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }
}
*/