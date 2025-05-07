import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/error_codes.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/login/data_access/check_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLogin {
  CheckDataDa checkDataDa = CheckDataDa();

  Future<void> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == ErrorCodes.userNotFoundErrorCode ||
            e.code == ErrorCodes.wrongPasswordErrorCode ||
            e.code == ErrorCodes.invalidCredentialsErrorCode) {
          throw FirebaseCredentialsExceptions(
              message: ExceptionMessages.firebaseInvalidCredentialsException);
        } else if (e.code == ErrorCodes.noConnectionErrorCode) {
          throw FirebaseNoConnectionException(
            message: ExceptionMessages.firebaseNoConnectionException,
          );
        } else if (e.code == ErrorCodes.invalidEmailErrorCode) {
          throw FirebaseInvalidEmail(
              message: ExceptionMessages.firebaseInvalidEmailMessage);
        } else {
          throw FirebaseUnknownException(
              message:
                  "${ExceptionMessages.firebaseUnknownException}\n${e.message}");
        }
      } catch (e) {
        throw GenericException(
            message: ExceptionMessages.genericExceptionMessage);
      }
    } else {
      throw EmptyFieldException(
        message: ExceptionMessages.emptyFieldMessage,
      );
    }
  }

  Future<bool> isUserCompleted() async {
    return checkDataDa.completedUserData();
  }
}
