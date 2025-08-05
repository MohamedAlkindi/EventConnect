import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';

class EditProfileDa {
  final _firestore = FirebaseFirestore.instance;
  final _userID = FirebaseUser().getUserID;

  Future<UserModel> getUserDetails() async {
    try {
      final result = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_userID)
          .get();

      var userData = UserModel.fromJson(result.data()!);
      return userData;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> updateProfileDetails(UserModel model) async {
    try {
      await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_userID)
          .update(model.toJson());
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
