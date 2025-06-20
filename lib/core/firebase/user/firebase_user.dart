import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/error_codes.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  User? get getUser => FirebaseAuth.instance.currentUser;

  String get getUserID => getUser!.uid;

  final _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
      {required String email, required String password}) async {
    try {
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
  }

  Future<void> signInUser(
      {required String email, required String password}) async {
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
  }

  Future<void> sendVerificationEmail() async {
    if (getUser != null) {
      try {
        await getUser!.sendEmailVerification();
      } catch (e) {
        throw Exception("Error ${e.toString()}");
      }
    } else {
      throw Exception("This user is invalid");
    }
  }

  bool get isVerified {
    if (getUser != null) {
      try {
        getUser!.reload();
        return getUser!.emailVerified;
      } catch (e) {
        throw Exception("Error ${e.toString()}");
      }
    } else {
      throw Exception("This user is invalid");
    }
  }

  Future<bool> isUserDataCompleted() async {
    try {
      final result = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(getUserID)
          .get();

      return result.exists ? true : false;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> deleteUser() async {
    try {
      // Check if user is signed in
      if (getUser == null) {
        throw Exception('No user is currently signed in');
      }

      // Try to delete the user
      await getUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // If the user needs to reauthenticate, you should handle this case
        // by prompting the user to sign in again before deletion
        throw Exception('Please sign in again before deleting your account');
      }
      throw Exception('Failed to delete user: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred while deleting the user: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
