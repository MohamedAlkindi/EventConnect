import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/manager/manager_edit_profile/business_logic/manager_edit_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'manager_edit_profile_state.dart';

class ManagerEditProfileCubit extends Cubit<ManagerEditProfileState> {
  ManagerEditProfileCubit() : super(ManagerEditProfileInitial());
  final _bl = ManagerEditProfileBL();

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

  Future<void> updateManagerProfile() async {
    try {
      emit(ManagerEditProfileLoading());
      await _bl.updateManagerProfile(
        location: newSelectedCity == null
            ? previouslySelectedCity!
            : newSelectedCity!,
        supabaseImageUrl: supabaseImageUrl!,
        profilePicPath: newSelectedImagePath,
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
      supabaseImageUrl = managerProfile.profilePic;
      userRole = managerProfile.role;

      emit(GotManagerProfile(managerProfile: managerProfile));
    } catch (e) {
      emit(ManagerEditProfileError(message: e.toString()));
    }
  }
}
