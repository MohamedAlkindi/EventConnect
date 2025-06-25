import 'dart:io';

import 'package:event_connect/features/manager/manager_homescreen/data_access/manager_homescreen_da.dart';

class ManagerHomescreenBl {
  final _dataAccess = ManagerHomescreenDa();

  Future<File> getManagerProfilePic() async {
    try {
      return _dataAccess.getUserProfilePic();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
