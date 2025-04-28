import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/user_homescreen/data_access/user_homescreen_da.dart';

class UserHomescreenBl {
  final UserHomescreenDa _dataAccess = UserHomescreenDa();
  final FirebaseUser _user = FirebaseUser();

  Future<File> convertBase64ToFile(String base64String) async {
    try {
      Uint8List bytes = base64Decode(base64String);
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/profile_pic.png');
      await tempFile.writeAsBytes(bytes);
      return tempFile;
    } catch (e) {
      throw Exception('Error converting Base64 to File: $e');
    }
  }

  Future<File> getUserProfilePic() async {
    final List<Map<String, dynamic>> result =
        await _dataAccess.getUserProfilePic();

    return convertBase64ToFile(result[0]['ProfilePic']);
  }

  Future<void> signOut() async {
    await _user.signOut();
  }
}
