import 'package:bloc/bloc.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/edit_profile/business_logic/edit_profile_bl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  final EditProfileBL _bl = EditProfileBL();
  final _user = FirebaseUser();

  Future<void> updateUserProfile({
    required String location,
    required XFile profilePic,
  }) async {
    try {
      final updatedInfo = UserModel(
        userID: _user.getUserID,
        location: location,
        profilePic: profilePic.path,
      );
      _bl.updateUserProfile(model: updatedInfo);
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
