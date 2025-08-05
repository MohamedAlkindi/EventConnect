import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/manager/manager_edit_profile/business_logic/manager_edit_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'manager_edit_profile_state.dart';

class ManagerEditProfileCubit extends Cubit<ManagerEditProfileState> {
  ManagerEditProfileCubit() : super(ManagerEditProfileInitial());
  final _bl = ManagerEditProfileBL();

  // TODO: Might change it to one var like the complete profile.
  // And might not, hehe,
  String? previouslySelectedCity;
  String? newSelectedCity;

  final ImagePicker _picker = ImagePicker();

  // This will come from the restored data which will contain the path
  // of the image in supabase.
  String? supabaseImageUrl;
  // String? cachedProfilePicPath;

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

  Future<void> updateManagerProfile(
      {required String cachedProfilePicPath}) async {
    try {
      emit(ManagerEditProfileLoading());
      await _bl.updateManagerProfile(
        location: newSelectedCity ?? previouslySelectedCity!,
        supabaseImageUrl: supabaseImageUrl!,
        newProfilePicPath: newSelectedImagePath,
        oldProfilePicPath: cachedProfilePicPath,
        role: userRole!,
      );
      emit(ManagerEditProfileSuccess());
    } catch (e) {
      emit(ManagerEditProfileError(message: e.toString()));
    }
  }

  Future<void> getManagerProfile() async {
    try {
      final managerProfile = await _bl.getManagerProfile();
      previouslySelectedCity = managerProfile.location;
      supabaseImageUrl = managerProfile.profilePicUrl;
      userRole = managerProfile.role;
      emit(GotManagerProfile(managerProfile: managerProfile));
    } catch (e) {
      emit(ManagerEditProfileError(message: e.toString()));
    }
  }

  ImageProvider getProfileImage(
    ManagerEditProfileState state,
    ManagerEditProfileCubit cubit,
  ) {
    if (state is GotManagerProfile) {
      if (state.managerProfile.cachedPicturePath == null) {
        return NetworkImage(
          "${state.managerProfile.profilePicUrl}?updated=${DateTime.now().millisecondsSinceEpoch}",
        );
      }
      return FileImage(File(state.managerProfile.cachedPicturePath!));
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
      {required ManagerEditProfileState state,
      required ManagerEditProfileCubit cubit}) {
    if (state is GotManagerProfile) {
      return state.managerProfile.location;
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
}
