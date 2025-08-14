import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/main.dart';

class CompleteProfileDa {
  final _firestore = FirebaseFirestore.instance;

  Future<void> completeProfile(UserModel model) async {
    try {
      await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(
            model.userID,
          )
          .set(
            model.toJson(),
          );
      globalUserModel = model;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
