import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';

class ManagerEditProfileDa {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<void> updateProfileDetails(UserModel model) async {
    try {
      await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .update(model.toJson());
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<UserModel> getManagerDetails() async {
    try {
      final result = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      var userData = UserModel.fromJson(result.data()!);
      return userData;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
