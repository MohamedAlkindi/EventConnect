import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions/register_exceptions/register_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/error_codes.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/register/data_access/insert_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRegister {
  InsertUser insertUser = InsertUser();

  Future<void> createUser({
    required String email,
    required String password,
    required String repeatPassword,
    required String userName,
  }) async {
    if (userName.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty ||
        email.isEmpty) {
      throw EmptyFieldException(
        message: ExceptionMessages.emptyFieldMessage,
      );
    }
    if (password == repeatPassword && userName.length >= 6) {
      try {
        await insertUser.isUnique(userName);
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == ErrorCodes.weakPasswordErrorCode) {
          throw FirebaseWeakPass(
              message: ExceptionMessages.firebaseWeakPassMessage);
        } else if (e.code == ErrorCodes.emailInUseErrorCode) {
          throw FirebaseEmailInUse(
              message: ExceptionMessages.firebaseEmailInUseMessage);
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
    } else if (password != repeatPassword) {
      throw PasswordsDontMatchException(
          message: ExceptionMessages.passwordsDontMatchMessage);
    }
  }
}
