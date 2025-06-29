import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/complete_profile/data_access/complete_profile_da.dart';
import 'package:event_connect/shared/image_storage_service.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileBl {
  final _dataAccess = CompleteProfileDa();
  final _user = FirebaseUser();
  final _imageService = ImageStorageService();

  late String imagePath;

  Future<void> finalizeProfile({
    required XFile? imageFile,
    required String city,
    required String role,
  }) async {
    if (city.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }

    if (imageFile == null) {
      // Handle default image (asset)
      imagePath = 'assets/images/generic_user.png';
    } else {
      // Handle user-selected image
      imagePath = imageFile.path;
    }

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
      throw Exception(ExceptionMessages.genericExceptionMessage);
    }
  }
}
