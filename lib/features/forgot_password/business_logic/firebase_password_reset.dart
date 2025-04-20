import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions/register_exceptions/register_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/error_codes.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePasswordReset {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
        message: ExceptionMessages.genericExceptionMessage,
      );
    }
  }
}
