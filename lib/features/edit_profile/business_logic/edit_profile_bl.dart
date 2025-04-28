import 'dart:convert';
import 'dart:io';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:event_connect/features/edit_profile/data_access/edit_profile_da.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBL {
  final EditProfileDA _da = EditProfileDA();

  Future<void> updateUserProfile({
    required String name,
    required String location,
    required XFile profilePic,
  }) async {
    if (name.length < 6) {
      throw ShortUsername(
        message: ExceptionMessages.shortUsernameMessage,
      );
    }
    await _da.updateUserProfile(
      name: name,
      location: location,
      profilePic: profilePic,
    );
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

  Future<Map<String, dynamic>> getUserProfile() async {
    final result = await _da.getUserProfile();
    return {
      UserTable.userNameColumnName: result[UserTable.userNameColumnName],
      UserTable.userLocationColumnName:
          result[UserTable.userLocationColumnName],
      UserTable.userProfilePicColumnName: await convertBase64ToXFile(
        result[UserTable.userProfilePicColumnName],
      ),
    };
  }
}
