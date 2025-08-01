import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/features/attendee/user_homescreen/business_logic/user_homescreen_bl.dart';
import 'package:flutter/material.dart';

part 'user_homescreen_state.dart';

class UserHomescreenCubit extends Cubit<UserHomescreenState> {
  final PageController pageController = PageController();

  UserHomescreenCubit() : super(UserHomescreenInitial()) {
    getUserProfilePic();
  }

  UserHomescreenBl userHomescreenBl = UserHomescreenBl();

  void onPageChanged(int index) {
    emit(UserHomescreenState(currentIndex: index, imageFile: state.imageFile));
  }

  void onBottomNavTap(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(microseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> getUserProfilePic() async {
    emit(UserHomescreenLoading());
    try {
      String userProfilePic = await userHomescreenBl.getUserProfilePic();

      emit(UserHomescreenState(
          currentIndex: state.currentIndex, imageFile: userProfilePic));
    } catch (e) {
      emit(UserHomescreenError(message: e.toString()));
    }
  }

  ImageProvider getPicturePath({required UserHomescreenState state}) {
    if (state.imageFile!.startsWith("https:/")) {
      return NetworkImage(state.imageFile!);
    }
    return FileImage(File(state.imageFile!));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  void reset() {
    emit(UserHomescreenInitial());
  }
}
