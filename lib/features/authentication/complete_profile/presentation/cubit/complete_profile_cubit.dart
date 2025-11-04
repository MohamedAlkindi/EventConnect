import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/features/authentication/complete_profile/business_logic/complete_profile_bl.dart';
import 'package:event_connect/features/authentication/email_confirmation/business_logic/email_cofirmation_logic.dart';
import 'package:flutter/material.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileCubit() : super(CompleteProfileInitial());

  final _bl = CompleteProfileBl();
  final _confirmation = EmailCofirmationLogic();
  final _user = FirebaseUser();

  // String defaultCity = "Al Mukalla";
  String selectedCity = "Al Mukalla";

  final ImagePicker _picker = ImagePicker();

  // String defaultImagePath = "assets/images/generic_user.png";
  String imagePath = "assets/images/generic_user.png";

  String selectedRole = "Attendee";

  void selectCity(String? city) {
    if (city != null) {
      selectedCity = city;
      emit(SelectedCity(selectedCity: selectedCity));
    }
  }

  void selectedImage(String? newImagePath) {
    if (newImagePath != null) {
      imagePath = newImagePath;
      emit(SelectedImage(selectedImagePath: imagePath));
    }
  }

  void selectRole(String role) {
    selectedRole = role;
    emit(SelectedRole(selectedRole: selectedRole));
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage(pickedImage.path);
    }
  }

  ImageProvider getImage({required CompleteProfileCubit cubit}) {
    if (cubit.imagePath.startsWith("assets/")) {
      return AssetImage(cubit.imagePath) as ImageProvider;
    }
    return FileImage(
      File(cubit.imagePath),
    ) as ImageProvider;
  }

  Future<void> completeProfile() async {
    emit(CompleteProfileLoading());
    try {
      await _bl.finalizeProfile(
        imagePath: imagePath,
        city: selectedCity,
        role: selectedRole,
      );
      emit(CompleteProfileSuccessful());
    } catch (e) {
      emit(CompleteProfileError(message: e.toString()));
    }
  }

  Future<void> isEmailConfirmed() async {
    try {
      emit(CompleteProfileLoading());
      emit(EmailConfirmed(isConfirmed: await _confirmation.isEmailConfirmed()));
    } catch (e) {
      emit(CompleteProfileError(message: e.toString()));
    }
  }

  // Based on role..
  void showUserHomescreen() async {
    final role = await _user.getUserRole();

    if (role == "Attendee") {
      emit(UserHomescreenRoute(
          userHomeScreenPageRoute: attendeeHomeScreenPageRoute));
    } else {
      emit(UserHomescreenRoute(
          userHomeScreenPageRoute: managerHomeScreenPageRoute));
    }
  }

  // Helper to get localized city name
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
