import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class ManagerProfileDa {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  // Future<UserModel> getManagerPicAndLocation() async {
  //   try {
  //     final doc = await _firestore
  //         .collection(UserCollection.userCollectionName)
  //         .doc(_user.getUserID)
  //         .get();

  //     final data = doc.data();

  //     return UserModel.fromJson(data!);
  //   } catch (e) {
  //     throw GenericException(e.toString());
  //   }
  // }

  Future<void> deleteUser() async {
    try {
      print('ManagerProfileDa: Starting delete user process...');
      // Store the user ID before deleting the Firebase Auth user
      final userID = _user.getUserID;
      print('ManagerProfileDa: User ID: $userID');

      // Delete Firestore document first
      print('ManagerProfileDa: Deleting Firestore document...');
      await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(userID)
          .delete();
      print('ManagerProfileDa: Firestore document deleted successfully');

      // Then delete the Firebase Auth user
      print('ManagerProfileDa: Deleting Firebase Auth user...');
      await _user.deleteUser();
      print('ManagerProfileDa: Firebase Auth user deleted successfully');
    } catch (e) {
      print('ManagerProfileDa: Delete user failed with error: $e');
      throw GenericException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _user.signOut();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
