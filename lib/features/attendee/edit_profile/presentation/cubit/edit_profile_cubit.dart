import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/edit_profile/business_logic/edit_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  final EditProfileBL _bl = EditProfileBL();

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

  Future<void> updateUserProfile() async {
    try {
      emit(EditProfileLoading());
      await _bl.updateUserProfile(
        location: newSelectedCity == null
            ? previouslySelectedCity!
            : newSelectedCity!,
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
