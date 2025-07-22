import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/manager/manager_edit_profile/data_access/manager_edit_profile_da.dart';

class ManagerEditProfileBL {
  final _dataAccess = ManagerEditProfileDa();
  final _user = FirebaseUser();
  final _imageCompression = ImageCompressionService();
  final _imageService = ImageStorageService();

  Future<void> updateManagerProfile({
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
                eventImageUrl: null,
                isEventPic: false,
                userID: _user.getUserID,
              ),
        role: role,
      );
      await _dataAccess.updateProfileDetails(updatedInfo);
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<UserModel> getManagerProfile() async {
    try {
      return await _dataAccess.getManagerDetails();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
