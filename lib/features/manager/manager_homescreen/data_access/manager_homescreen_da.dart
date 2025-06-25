import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class ManagerHomescreenDa {
  final FirebaseUser _user = FirebaseUser();
  final _firestore = FirebaseFirestore.instance;

  Future<File> getUserProfilePic() async {
    try {
      // get all user data.
      final doc = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      // extract the snapshot data.
      final profilePic = doc.data()?[UserCollection.userProfilePicDocumentName];

      return File(profilePic);
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
