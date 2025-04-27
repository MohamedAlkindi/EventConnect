import 'package:bloc/bloc.dart';
import 'package:event_connect/features/edit_profile/business_logic/edit_profile_bl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  final EditProfileBL _bl = EditProfileBL();

  Future<void> updateUserProfile({
    required String name,
    required String location,
    required XFile profilePic,
  }) async {
    try {
      await _bl.updateUserProfile(
        name: name,
        location: location,
        profilePic: profilePic,
      );
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(message: e.toString()));
    }
  }

  Future<void> getUserProfile() async {
    try {
      final userProfile = await _bl.getUserProfile();
      emit(GotUserProfile(userProfile: userProfile));
    } catch (e) {
      emit(EditProfileError(message: e.toString()));
    }
  }
}
