import 'dart:convert';
import 'dart:io';

import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class EditProfileDA {
  final FirebaseUser _user = FirebaseUser();
  final Database _db = AppDatabase.db;

  Future<Map<String, dynamic>> getUserProfile() async {
    final result = await _db.query(
      UserTable.userTableName,
      where: '${UserTable.userIDColumnName} = ?',
      whereArgs: [_user.getUserID],
    );
    return result.first;
  }

  Future<String> convertImageToBase64(XFile? imageFile) async {
    final bytes = await File(imageFile!.path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> updateUserProfile({
    required String name,
    required String location,
    required XFile profilePic,
  }) async {
    await _db.update(
      UserTable.userTableName,
      {
        UserTable.userNameColumnName: name,
        UserTable.userLocationColumnName: location,
        UserTable.userProfilePicColumnName: await convertImageToBase64(
          profilePic,
        ),
      },
      where: '${UserTable.userIDColumnName} = ?',
      whereArgs: [_user.getUserID],
    );
  }
}
