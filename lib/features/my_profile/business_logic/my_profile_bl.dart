import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:cross_file/cross_file.dart';

class MyProfileBL {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  // Convert XFile to base64 string
  Future<String> convertXFileToBase64(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      throw GenericException(
          message: 'Failed to convert file to base64: ${e.toString()}');
    }
  }

  // Convert base64 string to image bytes that can be used in UI
  Uint8List convertBase64ToImage(String base64String) {
    try {
      if (base64String.isEmpty) {
        throw GenericException(message: 'Base64 string is empty');
      }

      // Check if the string is a file path
      if (base64String.startsWith('/')) {
        final file = File(base64String);
        if (!file.existsSync()) {
          throw GenericException(
              message: 'Image file not found at path: $base64String');
        }
        return file.readAsBytesSync();
      }

      // Remove any potential data URL prefix
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',')[1];
      }

      // Validate base64 string format
      if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(cleanBase64)) {
        throw GenericException(message: 'Invalid base64 string format');
      }

      return base64Decode(cleanBase64);
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
