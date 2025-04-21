import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/features/user_homescreen/business_logic/user_homescreen_bl.dart';
import 'package:meta/meta.dart';

part 'user_homescreen_state.dart';

class UserHomescreenCubit extends Cubit<UserHomescreenState> {
  UserHomescreenCubit() : super(UserHomescreenInitial());
  UserHomescreenBl userHomescreenBl = UserHomescreenBl();

  Future<void> getUserProfilePic() async {
    emit(UserHomescreenLoading());
    try {
      File userProfilePic = await userHomescreenBl.getUserProfilePic();
      emit(GotUserProfilePic(imageFile: userProfilePic));
    } catch (e) {
      emit(UserHomescreenError(message: e.toString()));
    }
  }

  Future<void> userSignOut() async {
    emit(UserHomescreenLoading());
    try {
      await userHomescreenBl.signOut();
      emit(UserSignedOutSuccessfully());
    } catch (e) {
      emit(UserHomescreenError(message: e.toString()));
    }
  }
}
