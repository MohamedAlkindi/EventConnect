import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/complete_profile/data_access/complete_profile_da.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileBl {
  final _dataAccess = CompleteProfileDa();
  late String imagePath;

  Future<void> finalizeProfile({
    required XFile? imageFile,
    required String city,
    required String role,
  }) async {
    final FirebaseUser firebaseUser = FirebaseUser();

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
        userID: firebaseUser.getUserID,
        location: city,
        profilePic: imagePath,
        role: role,
      );
      await _dataAccess.completeProfile(user);
      // Send the data to be saved.
    } catch (e) {
      throw Exception(ExceptionMessages.genericExceptionMessage);
    }
  }
}
