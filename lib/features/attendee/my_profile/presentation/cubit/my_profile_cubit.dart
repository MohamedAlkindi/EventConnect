import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/my_profile/business_logic/my_profile_bl.dart';
import 'package:meta/meta.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());
  final MyProfileBL _businessLogic = MyProfileBL();

  Future<void> getUserPicAndName() async {
    try {
      final result = await _businessLogic.getUserPicAndLocation();
      emit(GotMyProfileInfo(userInfo: result));
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }

  Future<void> userSignOut() async {
    try {
      await _businessLogic.signOut();
      emit(UserSignedOutSuccessfully());
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      await _businessLogic.deleteUser();
      emit(UserDeletedSuccessfully());
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }
}
