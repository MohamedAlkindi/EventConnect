import 'dart:convert';
import 'dart:typed_data';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:event_connect/features/my_profile/data_access/my_profile_da.dart';

class MyProfileBL {
  final MyProfileDA _dataAccess = MyProfileDA();

  // Convert base64 string to image bytes that can be used in UI
  Uint8List convertBase64ToImage(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw GenericException(
          message: 'Failed to convert image: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUserPicAndName() async {
    try {
      final result = await _dataAccess.getUserPicAndName();
      return {
        UserTable.userProfilePicColumnName:
            convertBase64ToImage(result[UserTable.userProfilePicColumnName]),
        UserTable.userNameColumnName: result[UserTable.userNameColumnName],
        UserTable.userLocationColumnName:
            result[UserTable.userLocationColumnName],
      };
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      await _dataAccess.deleteUser();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }
}
