import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/edit_profile/data_access/edit_profile_da.dart';

class EditProfileBL {
  final _dataAccess = EditProfileDa();
  final _user = FirebaseUser();

  Future<void> updateUserProfile({
    required String location,
    required String profilePicPath,
  }) async {
    final updatedInfo = UserModel(
      userID: _user.getUserID,
      location: location,
      profilePic: profilePicPath,
    );
    try {
      await _dataAccess.updateProfileDetails(updatedInfo);
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      return await _dataAccess.getUserDetails();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
