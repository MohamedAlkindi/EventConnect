import 'package:bloc/bloc.dart';
import 'package:event_connect/features/complete_profile/business_logic/complete_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileCubit() : super(CompleteProfileInitial());

  final CompleteProfileBl _bl = CompleteProfileBl();

  final List<String> yemeniCities = [
    'Hadramout',
    "San'aa",
    'Aden',
    'Taiz',
    'Ibb',
    'Al Hudaydah',
    'Marib',
    'Al Mukalla'
  ];
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

  Future<void> completeProfile() async {
    emit(CompleteProfileLoading());
    try {
      await _bl.finalizeProfile(
        imageFile: XFile(imagePath),
        city: selectedCity,
        role: selectedRole,
      );
      emit(CompleteProfileSuccessul());
    } catch (e) {
      emit(CompleteProfileError(message: e.toString()));
    }
  }
}
