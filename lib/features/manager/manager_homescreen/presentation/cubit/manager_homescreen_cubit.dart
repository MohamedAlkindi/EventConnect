import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/features/manager/manager_homescreen/business_logic/manager_homescreen_bl.dart';
import 'package:flutter/material.dart';

part 'manager_homescreen_state.dart';

class ManagerHomescreenCubit extends Cubit<ManagerHomescreenState> {
  final PageController pageController = PageController();
  ManagerHomescreenCubit() : super(ManagerHomescreenInitial()) {
    getManagerProfilePic();
  }

  ManagerHomescreenBl managerHomescreenBl = ManagerHomescreenBl();

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

  Future<void> getManagerProfilePic() async {
    emit(ManagerHomescreenLoading());
    try {
      String managerProfilePic =
          await managerHomescreenBl.getManagerProfilePic();
      emit(ManagerHomescreenState(
          currentIndex: state.currentIndex, imageFile: managerProfilePic));
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
