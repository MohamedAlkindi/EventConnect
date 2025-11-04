import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/manager/manager_edit_profile/business_logic/manager_edit_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

part 'manager_edit_profile_state.dart';

class ManagerEditProfileCubit extends Cubit<ManagerEditProfileState> {
  ManagerEditProfileCubit() : super(ManagerEditProfileInitial());
  final _bl = ManagerEditProfileBL();

  // TODO: Might change it to one var like the complete profile.
  // And might not, hehe,
  String? newSelectedCity;

  final ImagePicker _picker = ImagePicker();

  String? newSelectedImagePath;

  String? userRole;

  void selectCity(String? city) {
    if (city != null) {
      newSelectedCity = city;
      emit(SelectedCity(selectedCity: newSelectedCity!));
    }
  }

  void selectedImage(String? imagePath) {
    if (imagePath != null) {
      newSelectedImagePath = imagePath;
      emit(SelectedImage(selectedImagePath: newSelectedImagePath!));
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage(pickedImage.path);
    }
  }

  UserModel? editedManagerModel;
  Future<void> updateManagerProfile({
    required String cachedImagePath,
    required String previouslySelectedCity,
    required String supabaseImageUrl,
    required String userRole,
  }) async {
    try {
      emit(ManagerEditProfileLoading());
      final updatedManagerInfo = await _bl.updateManagerProfile(
        location: newSelectedCity ?? previouslySelectedCity,
        supabaseImageUrl: supabaseImageUrl,
        newProfilePicPath: newSelectedImagePath,
        oldProfilePicPath: cachedImagePath,
        role: userRole,
      );
      editedManagerModel = updatedManagerInfo;
      emit(ManagerEditProfileSuccess());
    } catch (e) {
      emit(ManagerEditProfileError(message: e.toString()));
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
}
