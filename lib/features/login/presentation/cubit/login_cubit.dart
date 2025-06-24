import 'package:bloc/bloc.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/login/business_logic/firebase_login.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final _login = FirebaseLogin();
  final _user = FirebaseUser();

  Future<void> firebaseLogin({
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      emit(LoginLoading());
      await _login.loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      emit(LoginSuccessful());
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  void togglePasswordVisibility(bool currentVisibility) {
    emit(PasswordVisible(currentVisibility: !currentVisibility));
  }

  void isEmailConfirmed() {
    try {
      emit(EmailConfirmed(isConfirmed: _login.isEmailConfirmed()));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  void isDataCompleted() async {
    try {
      emit(DataCompleted(isDataCompleted: await _user.isUserDataCompleted()));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  // Based on role..
  void showUserHomescreen() async {
    final role = await _user.getUserRole();

    if (role == "Attendee") {
      emit(UserHomescreenState(
          userHomeScreenRoute: attendeeHomeScreenPageRoute));
    } else {
      emit(
          UserHomescreenState(userHomeScreenRoute: managerHomeScreenPageRoute));
    }
  }
}
