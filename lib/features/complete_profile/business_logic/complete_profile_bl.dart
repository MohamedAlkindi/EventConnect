import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/complete_profile/data_access/complete_profile_da.dart';

class CompleteProfileBl {
  final _dataAccess = CompleteProfileDa();
  final _userID = FirebaseUser().getUserID;
  final _imageService = ImageStorageService();
  final _imageCompression = ImageCompressionService();

  Future<void> finalizeProfile({
    required String imageFile,
    required String city,
    required String role,
  }) async {
    if (city.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }

    String profilePicUrl;
    String? cachedPicturePath;

    if (imageFile.startsWith('assets/')) {
      // If the image is an asset, do not upload or compress, just use the asset path as the profilePicUrl.
      profilePicUrl = imageFile;
      cachedPicturePath = null;
    } else {
      // Compress the image, upload it, and use the returned URL.
      final compressedPath =
          await _imageCompression.compressAndReplaceImage(imageFile);
      profilePicUrl = await _imageService.addAndReturnImageUrl(
        imagePath: compressedPath,
        userID: _userID,
        isEventPic: false,
      );
      cachedPicturePath = compressedPath;
    }

    try {
      final user = UserModel(
        userID: _userID,
        location: city,
        profilePicUrl: profilePicUrl,
        cachedPicturePath: cachedPicturePath,
        role: role,
      );
      await _dataAccess.completeProfile(user);
    } catch (e) {
      throw GenericException(ExceptionMessages.genericExceptionMessage);
    }
  }
}
