import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'welcome_screen_state.dart';

class WelcomeScreenCubit extends Cubit<WelcomeScreenState> {
  final PageController pageController = PageController();
  Timer? _timer;

  WelcomeScreenCubit() : super(WelcomeScreenInitial()) {
    _initializeCarousel();
  }

  void _initializeCarousel() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (state.currentPage < 3) {
        emit(WelcomeScreenState(currentPage: state.currentPage + 1));
      } else {
        emit(WelcomeScreenState(currentPage: 0));
      }
      pageController.animateToPage(
        state.currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int page) {
    emit(WelcomeScreenState(currentPage: page));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    pageController.dispose();
    return super.close();
  }
}
