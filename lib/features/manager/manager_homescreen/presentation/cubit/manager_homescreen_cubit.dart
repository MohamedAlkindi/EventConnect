import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';

part 'manager_homescreen_state.dart';

class ManagerHomescreenCubit extends Cubit<ManagerHomescreenState> {
  final PageController pageController = PageController();
  ManagerHomescreenCubit() : super(ManagerHomescreenInitial()) {
    getManagerProfilePic(editedImagePath: null);
  }

  // ManagerHomescreenBl managerHomescreenBl = ManagerHomescreenBl();

  void onPageChanged(int index) {
    emit(ManagerHomescreenState(
        currentIndex: index, imageFile: state.imageFile));
  }

  void onBottomNavTap(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(microseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ImageProvider getPicturePath({required ManagerHomescreenState state}) {
    if (state.imageFile!.startsWith("https:/")) {
      return NetworkImage(state.imageFile!);
    }
    return FileImage(File(state.imageFile!));
  }

  Future<void> getManagerProfilePic({required String? editedImagePath}) async {
    emit(ManagerHomescreenLoading());
    try {
      if (editedImagePath != null) {
        emit(ManagerHomescreenState(
            currentIndex: state.currentIndex, imageFile: editedImagePath));
      } else {
        emit(ManagerHomescreenState(
            currentIndex: state.currentIndex,
            imageFile: globalUserModel!.cachedPicturePath));
      }
      // String managerProfilePic =
      // await managerHomescreenBl.getManagerProfilePic();
    } catch (e) {
      emit(ManagerHomescreenError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
