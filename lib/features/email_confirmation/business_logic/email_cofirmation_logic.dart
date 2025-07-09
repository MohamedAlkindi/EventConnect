import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class EmailCofirmationLogic {
  final _user = FirebaseUser();

  Future<void> sendEmailConfirmation() async {
    try {
      await _user.sendVerificationEmail();
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }

  Future<bool> isEmailConfirmed() async {
    try {
      return await _user.isVerified;
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }
}
