import 'dart:io';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/authentication/complete_profile/data_access/complete_profile_da.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CompleteProfileBl {
  final _dataAccess = CompleteProfileDa();
  final _userID = FirebaseUser().getUserID;
  final _imageService = ImageStorageService();
  final _imageCompression = ImageCompressionService();

  Future<void> finalizeProfile({
    required String imagePath,
    required String city,
    required String role,
  }) async {
    if (city.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }

    String profilePicUrl;

    if (imagePath.startsWith('assets/')) {
      // Upload the temporary file to Supabase.
      final tempFile = await saveAssetPicture(imagePath);
      profilePicUrl = await _imageService.addAndReturnImageUrl(
        imagePath: tempFile.path,
        userID: _userID,
        isEventPic: false,
      );

      // Clean up the temporary file
      await tempFile.delete();
    } else {
      // Compress the image, upload it, and use the returned URL.
      final compressedPath =
          await _imageCompression.compressAndReplaceImage(imagePath);
      profilePicUrl = await _imageService.addAndReturnImageUrl(
        imagePath: compressedPath,
        userID: _userID,
        isEventPic: false,
      );
    }

    try {
      final user = UserModel(
        userID: _userID,
        location: city,
        profilePicUrl: profilePicUrl,
        cachedPicturePath: null,
        role: role,
      );
      await _dataAccess.completeProfile(user);
    } catch (e) {
      throw GenericException(ExceptionMessages.genericExceptionMessage);
    }
  }
}

Future<File> saveAssetPicture(String imagePath) async {
  // Load asset file and create a temporary file for upload.
  final ByteData data = await rootBundle.load(imagePath);
  final List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  // Create a temporary file
  final tempDir = await getTemporaryDirectory();
  final tempFile = File(
      '${tempDir.path}/temp_asset_${DateTime.now().millisecondsSinceEpoch}.png');
  await tempFile.writeAsBytes(bytes);

  return tempFile;
}
