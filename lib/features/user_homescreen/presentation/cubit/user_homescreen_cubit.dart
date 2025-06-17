import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/features/user_homescreen/business_logic/user_homescreen_bl.dart';
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
      File userProfilePic = await userHomescreenBl.getUserProfilePic();
      emit(UserHomescreenState(
          currentIndex: state.currentIndex, imageFile: userProfilePic));
    } catch (e) {
      emit(UserHomescreenError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
