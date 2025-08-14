import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/edit_profile/business_logic/edit_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  final EditProfileBL _bl = EditProfileBL();

  String? newSelectedCity;

  final ImagePicker _picker = ImagePicker();

  String? newSelectedImagePath;

  void selectCity(String? city) {
    if (city != null) {
      newSelectedCity = city;
      emit(SelectedCity(selectedCity: newSelectedCity!));
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage(pickedImage.path);
    }
  }

  void selectedImage(String? imagePath) {
    if (imagePath != null) {
      newSelectedImagePath = imagePath;
      emit(SelectedImage(selectedImagePath: newSelectedImagePath!));
    }
  }

  ImageProvider getProfileImage(UserModel userModel) {
    if (userModel.cachedPicturePath == null) {
      return NetworkImage(
        "${userModel.profilePicUrl}?updated=${DateTime.now().millisecondsSinceEpoch}",
      );
    } else if (newSelectedImagePath != null) {
      return FileImage(File(newSelectedImagePath!));
    }
    return FileImage(File(userModel.cachedPicturePath!));
  }

  String getCity({required UserModel userModel}) {
    if (newSelectedCity != null) {
      return newSelectedCity!;
    }
    return userModel.location;
  }

  String getCityDisplay(String value, AppLocalizations l10n) {
    final idx = cities.indexOf(value);
    final localized = [
      l10n.cityHadramout,
      l10n.citySanaa,
      l10n.cityAden,
      l10n.cityTaiz,
      l10n.cityIbb,
      l10n.cityHudaydah,
      l10n.cityMarib,
      l10n.cityMukalla,
    ];
    return idx >= 0 ? localized[idx] : value;
  }

  UserModel? editedUserModel;
  // The cached will be fetched from the cached path.
  Future<void> updateUserProfile({
    required String cachedImagePath,
    required String previouslySelectedCity,
    required String supabaseImageUrl,
    required String userRole,
  }) async {
    try {
      emit(EditProfileLoading());
      final updatedUserModel = await _bl.updateUserProfile(
        location: newSelectedCity ?? previouslySelectedCity,
        supabaseImageUrl: supabaseImageUrl,
        newProfilePicPath: newSelectedImagePath,
        oldProfilePicPath: cachedImagePath,
        role: userRole,
      );
      editedUserModel = updatedUserModel;
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(message: e.toString()));
    }
  }
}
