import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';

class EditProfileBL {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<void> updateUserProfile({
    required UserModel model,
  }) async {
    await _firestore
        .collection(UserCollection.userCollectionName)
        .doc(_user.getUserID)
        .update(model.toJson());
  }

  Future<UserModel> getUserProfile() async {
    final result = await _firestore
        .collection(UserCollection.userCollectionName)
        .doc(_user.getUserID)
        .get();

    var userData = UserModel.fromJson(result.data()!);
    return userData;
  }
}
