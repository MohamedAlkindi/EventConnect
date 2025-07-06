import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/attendee/edit_profile/data_access/edit_profile_da.dart';

class EditProfileBL {
  final _dataAccess = EditProfileDa();
  final _user = FirebaseUser();
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
        userID: _user.getUserID,
        location: location,
        profilePic: imagePath == null
            ? supabaseImageUrl
            : await _imageService.updateAndReturnImageUrl(
                newImagePath: imagePath,
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
