import 'dart:io';

import 'package:event_connect/features/attendee/user_homescreen/data_access/user_homescreen_da.dart';

class UserHomescreenBl {
  final _dataAccess = UserHomescreenDa();

  Future<File> getUserProfilePic() async {
    try {
      return _dataAccess.getUserProfilePic();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
