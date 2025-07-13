import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/edit_profile/business_logic/edit_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  final EditProfileBL _bl = EditProfileBL();

  // TODO: Might change it to one var like the complete profile.
  // And might not, hehe,
  String? previouslySelectedCity;
  String? newSelectedCity;

  final ImagePicker _picker = ImagePicker();

  // This will come from the restored data which will contain the path
  // of the image in supabase.
  String? supabaseImageUrl;

  String? newSelectedImagePath;

  String? userRole;

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

  ImageProvider getProfileImage(
    EditProfileState state,
    EditProfileCubit cubit,
  ) {
    if (state is GotUserProfile) {
      return NetworkImage(
        "${state.userProfile.profilePic}?updated=${DateTime.now().millisecondsSinceEpoch}",
      );
    } else if (state is SelectedImage) {
      return FileImage(File(state.selectedImagePath));
    } else if (cubit.newSelectedImagePath != null) {
      return FileImage(File(cubit.newSelectedImagePath!));
    } else if (cubit.supabaseImageUrl != null) {
      return NetworkImage(
        "${cubit.supabaseImageUrl!}updated=${DateTime.now().millisecondsSinceEpoch}",
      );
    }
    return const AssetImage('assets/images/generic_user.png');
  }

  String getCity(
      {required EditProfileState state, required EditProfileCubit cubit}) {
    if (state is GotUserProfile) {
      return state.userProfile.location;
    } else if (state is SelectedCity) {
      return state.selectedCity;
    } else if (cubit.newSelectedCity != null) {
      return cubit.newSelectedCity!;
    }
    return cubit.previouslySelectedCity ?? "Al Mukalla";
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

  Future<void> updateUserProfile() async {
    try {
      emit(EditProfileLoading());
      await _bl.updateUserProfile(
        location: newSelectedCity ?? previouslySelectedCity!,
        supabaseImageUrl: supabaseImageUrl!,
        profilePicPath: newSelectedImagePath,
        role: userRole!,
      );
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(message: e.toString()));
    }
  }

  Future<void> getUserProfile() async {
    try {
      final userProfile = await _bl.getUserProfile();
      previouslySelectedCity = userProfile.location;
      supabaseImageUrl = userProfile.profilePic;
      userRole = userProfile.role;

      emit(GotUserProfile(userProfile: userProfile));
    } catch (e) {
      emit(EditProfileError(message: e.toString()));
    }
  }
}
