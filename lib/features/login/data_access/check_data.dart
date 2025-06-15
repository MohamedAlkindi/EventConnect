import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class CheckData {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<bool> isUserDataCompleted() async {
    try {
      final result = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      return result.exists ? true : false;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
