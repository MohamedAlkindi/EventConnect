import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';

class MyProfileDa {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<UserModel> getUserPicAndLocation() async {
    try {
      final doc = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      final data = doc.data();

      return UserModel.fromJson(data!);
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> deleteUser() async {
    try {
      await _user.deleteUser();

      await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .delete();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
