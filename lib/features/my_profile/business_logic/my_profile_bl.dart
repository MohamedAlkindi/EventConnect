import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/my_profile/data_access/my_profile_da.dart';

class MyProfileBL {
  final _dataAccess = MyProfileDa();
  Future<UserModel> getUserPicAndLocation() async {
    try {
      // Put it in a variable for a better debugging "not nec."
      return await _dataAccess.getUserPicAndLocation();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      _dataAccess.deleteUser();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }
}
