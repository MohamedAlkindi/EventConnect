part of 'welcome_screen_cubit.dart';

class WelcomeScreenState {
  final int currentPage;

  WelcomeScreenState({required this.currentPage});
}

class WelcomeScreenInitial extends WelcomeScreenState {
  WelcomeScreenInitial() : super(currentPage: 0);
}
