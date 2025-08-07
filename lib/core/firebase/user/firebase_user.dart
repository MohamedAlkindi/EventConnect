import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/error_codes.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/shared/image_caching_setup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  User? get getUser => FirebaseAuth.instance.currentUser;
  String get getUserID => getUser!.uid;
  final _imageCaching = ImageCachingSetup();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      globalUserModel = await getUserInfo();
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
      throw GenericException(ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<void> signInUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      globalUserModel = await getUserInfo();
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
      throw GenericException(ExceptionMessages.genericExceptionMessage);
    }
  }

  Future<UserModel> getUserInfo() async {
    try {
      final doc = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(getUserID)
          .get();

      final data = doc.data();

      final userModel = UserModel.fromJson(data!);
      final imagePath = await _imageCaching
          .downloadAndCacheImageByUrl(userModel.profilePicUrl);
      userModel.cachedPicturePath = imagePath;
      return userModel;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> sendVerificationEmail() async {
    if (getUser != null) {
      try {
        await getUser!.sendEmailVerification();
      } catch (e) {
        throw GenericException(e.toString());
      }
    } else {
      throw GenericException("This user is invalid");
    }
  }

  Future<bool> get isVerified async {
    if (getUser != null) {
      try {
        await getUser!.reload();
        return getUser!.emailVerified;
      } catch (e) {
        throw GenericException(e.toString());
      }
    } else {
      throw GenericException("This user is invalid");
    }
  }

  /// Sends a password reset email to the given email address.
  ///
  /// Common reasons for not receiving the email:
  /// - The email address is incorrect or not registered.
  /// - The email is in the spam/junk folder.
  /// - There are issues with Firebase configuration (e.g., email template not set, domain not whitelisted).
  /// - The app is using the wrong Firebase project/environment.
  /// - The email sending quota is exceeded.
  ///
  /// This method throws a [GenericException] for unknown errors.
  Future<void> sendResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw GenericException("Email address cannot be empty.");
      }
      // Optionally, validate email format here if needed.
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors for better debugging
      if (e.code == 'user-not-found') {
        throw GenericException("No user found for that email.");
      } else if (e.code == 'invalid-email') {
        throw GenericException("The email address is not valid.");
      } else if (e.code == 'missing-android-pkg-name' ||
          e.code == 'missing-continue-uri' ||
          e.code == 'missing-ios-bundle-id' ||
          e.code == 'invalid-continue-uri' ||
          e.code == 'unauthorized-continue-uri') {
        throw GenericException(
            "There is a configuration issue with your Firebase project. Please check your Firebase console settings for password reset.");
      } else {
        throw GenericException("Firebase error: ${e.message}");
      }
    } catch (e) {
      throw GenericException(e.toString());
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
      throw GenericException(e.toString());
    }
  }

  Future<String> getUserRole() async {
    try {
      final document = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(getUserID)
          .get();

      return document.data()?["role"] as String;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      // Check if user is signed in
      if (getUser == null) {
        throw GenericException('No user is currently signed in');
      }

      // Try to delete the user
      await getUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // If the user needs to reauthenticate, you should handle this case
        // by prompting the user to sign in again before deletion
        throw GenericException(
            'Please sign in again before deleting your account');
      }
      throw GenericException('Failed to delete user: ${e.message}');
    } catch (e) {
      throw GenericException('An error occurred while deleting the user: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
