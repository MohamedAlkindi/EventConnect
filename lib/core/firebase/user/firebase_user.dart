import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  User? get getUser => FirebaseAuth.instance.currentUser;

  String get getUserID => getUser!.uid;

  Future<void> deleteUser() async {
    try {
      // Check if user is signed in
      if (getUser == null) {
        throw Exception('No user is currently signed in');
      }

      // Try to delete the user
      await getUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // If the user needs to reauthenticate, you should handle this case
        // by prompting the user to sign in again before deletion
        throw Exception('Please sign in again before deleting your account');
      }
      throw Exception('Failed to delete user: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred while deleting the user: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
