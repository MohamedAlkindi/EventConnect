import 'package:bloc/bloc.dart';
import 'package:event_connect/features/login/business_logic/firebase_login.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  FirebaseLogin login = FirebaseLogin();

  Future<void> firebaseLogin({
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      emit(LoginLoading());
      await login.loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (await login.isUserCompleted()) {
        emit(LoginSuccessfulWithData());
      } else {
        emit(LoginSuccessfulWithoutData());
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  void togglePasswordVisibility(bool currentVisibility) {
    emit(PasswordVisible(currentVisibility: !currentVisibility));
  }
}
