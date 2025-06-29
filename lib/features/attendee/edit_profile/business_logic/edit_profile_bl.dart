import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/edit_profile/data_access/edit_profile_da.dart';
import 'package:event_connect/shared/image_storage_service.dart';

class EditProfileBL {
  final _dataAccess = EditProfileDa();
  final _user = FirebaseUser();
  final _imageService = ImageStorageService();

  Future<void> updateUserProfile({
    required String location,
    required String supabaseImageUrl,
    required String? profilePicPath,
    required String role,
  }) async {
    try {
      final updatedInfo = UserModel(
        userID: _user.getUserID,
        location: location,
        profilePic: profilePicPath == null
            ? supabaseImageUrl
            : await _imageService.updateAndReturnImageUrl(
                newImagePath: profilePicPath,
                imageUrl: null,
                isEventPic: false,
                userID: _user.getUserID,
              ),
        role: role,
      );
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
