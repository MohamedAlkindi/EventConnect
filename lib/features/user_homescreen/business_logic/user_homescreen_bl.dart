import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class UserHomescreenBl {
  // final UserHomescreenDa _dataAccess = UserHomescreenDa();
  final FirebaseUser _user = FirebaseUser();
  final _firestore = FirebaseFirestore.instance;

  // Future<File> convertBase64ToFile(String base64String) async {
  //   try {
  //     Uint8List bytes = base64Decode(base64String);
  //     final tempDir = await Directory.systemTemp.createTemp();
  //     final tempFile = File('${tempDir.path}/profile_pic.png');
  //     await tempFile.writeAsBytes(bytes);
  //     return tempFile;
  //   } catch (e) {
  //     throw Exception('Error converting Base64 to File: $e');
  //   }
  // }

  Future<File> getUserProfilePic() async {
    // final List<Map<String, dynamic>> result =
    // await _dataAccess.getUserProfilePic();

    // get all user data.
    final doc = await _firestore
        .collection(UserCollection.userCollectionName)
        .doc(_user.getUserID)
        .get();

    // extract the snapshot data.
    final profilePic = doc.data()?[UserCollection.userProfilePicDocumentName];

    return File(profilePic);
  }

  Future<void> signOut() async {
    await _user.signOut();
  }
}
