import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/error_codes.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePasswordReset {
  final _user = FirebaseUser();

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }
    try {
      await _user.sendResetEmail(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == ErrorCodes.userNotFoundErrorCode) {
        throw FirebaseCredentialsExceptions(
            message: ExceptionMessages.firebaseInvalidCredentialsException);
      } else if (e.code == ErrorCodes.invalidEmailErrorCode) {
        throw FirebaseInvalidEmail(
            message: ExceptionMessages.firebaseInvalidEmailMessage);
      } else {
        throw FirebaseUnknownException(
            message: ExceptionMessages.firebaseUnknownException);
      }
    } catch (e) {
      throw GenericException(
        e.toString(),
      );
    }
  }
}
