import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class UserHomescreenDa {
  final FirebaseUser _user = FirebaseUser();
  final _firestore = FirebaseFirestore.instance;

  Future<String> getUserProfilePic() async {
    try {
      // get all user data.
      final doc = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      // extract the snapshot data.
      final profilePic =
          doc.data()?[UserCollection.userProfilePicUrlDocumentName];

      return profilePic;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
