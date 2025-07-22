import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/attendee/edit_profile/data_access/edit_profile_da.dart';

class EditProfileBL {
  final _dataAccess = EditProfileDa();
  final _userID = FirebaseUser().getUserID;
  final _imageService = ImageStorageService();
  final _imageCompression = ImageCompressionService();

  Future<void> updateUserProfile({
    required String location,
    required String supabaseImageUrl,
    required String? profilePicPath,
    required String role,
  }) async {
    try {
      final String? imagePath = profilePicPath != null
          ? await _imageCompression.compressAndReplaceImage(profilePicPath)
          : null;

      final updatedInfo = UserModel(
        userID: _userID,
        location: location,
        profilePic: imagePath == null
            ? supabaseImageUrl
            : await _imageService.updateAndReturnImageUrl(
                newImagePath: imagePath,
                eventImageUrl: null,
                isEventPic: false,
                userID: _userID,
              ),
        role: role,
      );
      await _dataAccess.updateProfileDetails(updatedInfo);
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      return await _dataAccess.getUserDetails();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
