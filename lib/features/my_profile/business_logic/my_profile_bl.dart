import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class MyProfileBL {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  // Convert base64 string to image bytes that can be used in UI
  Uint8List convertBase64ToImage(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw GenericException(
          message: 'Failed to convert image: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUserPicAndLocation() async {
    try {
      final doc = await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .get();

      final data = doc.data();

      return {
        UserCollection.userProfilePicDocumentName: convertBase64ToImage(
            data?[UserCollection.userProfilePicDocumentName]),
        UserCollection.userLocationDocumentName:
            data?[UserCollection.userLocationDocumentName],
      };
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      // await _dataAccess.deleteUser();
      await _firestore
          .collection(UserCollection.userCollectionName)
          .doc(_user.getUserID)
          .delete();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }
}
