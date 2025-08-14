import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';

part 'user_homescreen_state.dart';

class UserHomescreenCubit extends Cubit<UserHomescreenState> {
  final PageController pageController = PageController();

  UserHomescreenCubit() : super(UserHomescreenInitial()) {
    // Obviously first time starts with null so it fetches the image from the beginning.
    getUserProfilePic(editedImagePath: null);
  }

  // UserHomescreenBl userHomescreenBl = UserHomescreenBl();

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

  Future<void> getUserProfilePic({required String? editedImagePath}) async {
    emit(UserHomescreenLoading());
    try {
      // Similar to my profile, but instead of getting the full model we get the new cached image.
      // IF made any changes to it.
      if (editedImagePath != null) {
        emit(UserHomescreenState(
            currentIndex: state.currentIndex, imageFile: editedImagePath));
      } else {
        emit(UserHomescreenState(
            currentIndex: state.currentIndex,
            imageFile: globalUserModel!.cachedPicturePath!));
      }
    } catch (e) {
      emit(UserHomescreenError(message: e.toString()));
    }
  }

  ImageProvider getPicturePath({required UserHomescreenState state}) {
    if (state.imageFile!.startsWith("htt")) {
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
    pageController.jumpToPage(0);
    emit(UserHomescreenInitial());
  }
}
