import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class FirebaseRegister {
  Future<void> createUser({
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    final user = FirebaseUser();

    if (password.isEmpty || repeatPassword.isEmpty || email.isEmpty) {
      throw EmptyFieldException(
        message: ExceptionMessages.emptyFieldMessage,
      );
    }
    if (password == repeatPassword) {
      try {
        await user.registerUser(email: email, password: password);
        await user.sendVerificationEmail();
      } catch (e) {
        throw GenericException(e.toString());
      }
    } else if (password != repeatPassword) {
      throw PasswordsDontMatchException(
          message: ExceptionMessages.passwordsDontMatchMessage);
    }
  }
}
