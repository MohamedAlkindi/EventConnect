import 'package:event_connect/core/firebase/user/firebase_user.dart';

class EmailCofirmationLogic {
  final _user = FirebaseUser();

  Future<void> sendEmailConfirmation() async {
    try {
      await _user.sendVerificationEmail();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<bool> isEmailConfirmed() async {
    try {
      return await _user.isVerified;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
