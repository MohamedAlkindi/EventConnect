import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<XFile> convertBase64ToXFile(String base64String) async {
    try {
      final decodedBytes = base64Decode(base64String);
      final tempDir = Directory.systemTemp;
      final tempPath = '${tempDir.path}/temp_image.jpg';

      final file = File(tempPath);
      await file.writeAsBytes(decodedBytes);

      return XFile(file.path);
    } catch (e) {
      throw Exception('Failed to convert base64 to XFile: $e');
    }
  }

  Future<UserModel> getUserProfile() async {
    final result = await _firestore
        .collection(UserCollection.userCollectionName)
        .doc(_user.getUserID)
        .get();

    var userData = await UserModel.fromJson(result.data()!);
    return userData;
    //   final result = await _da.getUserProfile();
    //   return {
    //     UserTable.userNameColumnName: result[UserTable.userNameColumnName],
    //     UserTable.userLocationColumnName:
    //         result[UserTable.userLocationColumnName],
    //     UserTable.userProfilePicColumnName: await convertBase64ToXFile(
    //       result[UserTable.userProfilePicColumnName],
    //     ),
    //   };
    // }
  }
}
