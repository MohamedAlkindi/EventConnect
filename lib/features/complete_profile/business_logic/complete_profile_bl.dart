import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/complete_profile/data_access/complete_profile_da.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileBl {
  final _dataAccess = CompleteProfileDa();
  final _user = FirebaseUser();
  final _imageService = ImageStorageService();
  final _imageCompression = ImageCompressionService();

  Future<void> finalizeProfile({
    required XFile? imageFile,
    required String city,
    required String role,
  }) async {
    if (city.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }
    final imagePath = await _imageCompression.compressAndReplaceImage(
        imageFile?.path ?? 'assets/images/generic_user.png');
    try {
      // Create a map that contains the data for photo and location.
      final user = UserModel(
        userID: _user.getUserID,
        location: city,
        profilePic: await _imageService.addAndReturnImageUrl(
          imagePath: imagePath,
          eventName: null,
          userID: _user.getUserID,
          isEventPic: false,
        ),
        role: role,
      );
      await _dataAccess.completeProfile(user);
      // Send the data to be saved.
    } catch (e) {
      throw GenericException(ExceptionMessages.genericExceptionMessage);
    }
  }
}
