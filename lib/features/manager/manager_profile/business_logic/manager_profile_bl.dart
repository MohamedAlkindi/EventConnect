import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/manager/manager_profile/data_access/manager_profile_da.dart';

class ManagerProfileBl {
  final _dataAccess = ManagerProfileDa();
  final _user = FirebaseUser();

  Future<UserModel> getManagerPicAndLocation() async {
    try {
      // Put it in a variable for a better debugging "not nec."
      return await _dataAccess.getManagerPicAndLocation();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _user.signOut();
  }

  Future<void> deleteUser() async {
    try {
      await _dataAccess.deleteUser();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }
}
