import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';

class CompleteProfileDa {
  final _user = FirebaseUser();
  final _firestore = FirebaseFirestore.instance;

  Future<void> completeProfile(UserModel model) async {
    await _firestore
        .collection(UserCollection.userCollectionName)
        .doc(
          _user.getUserID,
        )
        .set(
          model.toJson(),
        );
  }
}
