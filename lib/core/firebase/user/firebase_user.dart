import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  User? get getUser => FirebaseAuth.instance.currentUser;

  String get getUserID => getUser!.uid;
}
