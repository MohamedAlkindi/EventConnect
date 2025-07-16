import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/business_logic/my_profile_bl.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());
  final MyProfileBL _businessLogic = MyProfileBL();

  Future<void> getUserPic() async {
    try {
      final result = await _businessLogic.getUserPicAndLocation();
      emit(GotMyProfileInfo(userPic: result));
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

  ImageProvider getPicturePath(GotMyProfileInfo state) {
    if (state.userPic.isNotEmpty && state.userPic.startsWith("http")) {
      return NetworkImage(
        "${state.userPic}${state.userPic.contains('?') ? '&' : '?'}updated=${DateTime.now().millisecondsSinceEpoch}",
      );
    } else if (File(state.userPic).existsSync()) {
      return FileImage(File(state.userPic));
    }
    return AssetImage('assets/images/generic_user.png');
  }

  // method to reset cubit and all cached data after logging out or deleting account.
  void resetAllCubits({required BuildContext context}) {
    context.read<AllEventsCubit>().reset();
    context.read<MyEventsCubit>().reset();
    context.read<UserHomescreenCubit>().reset();
    emit(MyProfileInitial());
  }
}
