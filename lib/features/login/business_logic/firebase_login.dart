import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class FirebaseLogin {
  final _user = FirebaseUser();
  Future<void> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _user.signInUser(email: email, password: password);
      } catch (e) {
        throw GenericException(e.toString());
      }
    } else {
      throw EmptyFieldException(
        message: ExceptionMessages.emptyFieldMessage,
      );
    }
  }

  Future<bool> isEmailConfirmed() async {
    try {
      return await _user.isVerified;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<bool> isDataCompleted() async {
    try {
      bool isDataCompleted = await _user.isUserDataCompleted();
      return isDataCompleted;
    } catch (e) {
      throw GenericException("Error ${e.toString()}");
    }
  }

  Future<String> getUserRole() async {
    try {
      // More maintainable.
      final role = await _user.getUserRole();

      return role;
    } catch (e) {
      throw GenericException("Error ${e.toString()}");
    }
  }
}
