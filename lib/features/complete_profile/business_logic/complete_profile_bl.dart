import 'dart:convert';
import 'dart:io';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/complete_profile/data_access/complete_profile_da.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileBl {
  late String base64String;

  final CompleteProfileDa _dataAccess = CompleteProfileDa();

  // Convert XFile to a base64 string for saving in the database
  Future<String> convertImageToBase64(XFile? imageFile) async {
    final bytes = await File(imageFile!.path).readAsBytes();
    return base64Encode(bytes);
  }

  // Helper method to load an asset image as bytes
  Future<List<int>> _loadAssetImageAsBytes(String assetPath) async {
    final byteData = await rootBundle.load(assetPath); // Load the asset
    return byteData.buffer.asUint8List(); // Convert to bytes
  }

  Future<void> finalizeProfile(
      {required XFile? imageFile, required String city}) async {
    if (city.isEmpty) {
      throw EmptyFieldException(message: ExceptionMessages.emptyFieldMessage);
    }

    if (imageFile == null ||
        imageFile.path == 'assets/images/generic_user.png') {
      // Handle default image (asset)
      final bytes =
          await _loadAssetImageAsBytes('assets/images/generic_user.png');
      base64String = base64Encode(bytes);
    } else {
      // Handle user-selected image
      base64String = await convertImageToBase64(imageFile);
    }

    try {
      // Create a map that contains the data for photo and location.
      Map<String, dynamic> updatedData = {
        'ProfilePic': base64String,
        'Location': city,
      };

      // Send the data to be saved.
      _dataAccess.finalizeProfile(updatedData: updatedData);
    } catch (e) {
      throw Exception(ExceptionMessages.genericExceptionMessage);
    }
  }
}
