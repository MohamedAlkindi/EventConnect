import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class MyProfileDa {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<String> getUserPic() async {
    try {
      final doc = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      final data = doc.data();

      // Extract only the profile picture field
      final profilePic = data?[UserCollection.userProfilePicUrlDocumentName];

      return profilePic ?? '';
    } catch (e) {
      throw GenericException(e.toString());
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
      throw GenericException(e.toString());
    }
  }
}
