import 'dart:io';

import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/user_homescreen/data_access/user_homescreen_da.dart';

class UserHomescreenBl {
  final _dataAccess = UserHomescreenDa();
  final _user = FirebaseUser();

  Future<File> getUserProfilePic() async {
    try {
      return _dataAccess.getUserProfilePic();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _user.signOut();
  }
}
