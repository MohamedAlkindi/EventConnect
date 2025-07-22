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

  // Based on role..
  Future<String> getUserRole() async {
    try {
      // More maintainable.
      final role = await _user.getUserRole();

      return role;
    } catch (e) {
      throw GenericException("Error ${e.toString()}");
    }
  }

  Future<bool> isDataCompleted() async {
    try {
      bool isCompeleted = await _user.isUserDataCompleted();
      return isCompeleted;
    } catch (e) {
      throw GenericException("Error ${e.toString()}");
    }
  }
}
