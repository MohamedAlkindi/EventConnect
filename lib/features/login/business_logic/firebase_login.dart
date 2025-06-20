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
        throw Exception("Error ${e.toString()}");
      }
    } else {
      throw EmptyFieldException(
        message: ExceptionMessages.emptyFieldMessage,
      );
    }
  }

  bool isEmailConfirmed() {
    try {
      return _user.isVerified;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
