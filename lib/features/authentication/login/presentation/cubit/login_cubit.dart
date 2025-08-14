import 'package:bloc/bloc.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/features/authentication/login/business_logic/firebase_login.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final _loginLogic = FirebaseLogin();

  Future<void> firebaseLogin({
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      emit(LoginLoading());
      await _loginLogic.loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      emit(LoginSuccessful());
    } catch (e) {
      String messageId = ExceptionMessages.genericExceptionMessage;

      // Check for known custom exceptions with a message property
      if (e is EmptyFieldException) {
        messageId = e.message;
      } else if (e is FirebaseCredentialsExceptions) {
        messageId = e.message;
      } else if (e is GenericException) {
        messageId = e.message;
      } else if (e is FirebaseInvalidEmail) {
        messageId = e.message;
      } else if (e is FirebaseUnknownException) {
        messageId = e.message;
      } else if (e is FirebaseNoConnectionException) {
        messageId = e.message;
      }
      emit(LoginError(message: messageId));
    }
  }

  void togglePasswordVisibility(bool currentVisibility) {
    emit(PasswordVisible(currentVisibility: !currentVisibility));
  }

  Future<void> isEmailConfirmed() async {
    try {
      emit(EmailConfirmed(isConfirmed: await _loginLogic.isEmailConfirmed()));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  void isDataCompleted() async {
    try {
      bool isDataCompleted = await _loginLogic.isDataCompleted();
      emit(DataCompleted(isDataCompleted: isDataCompleted));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  // Based on role..
  void showUserHomescreen() async {
    final role = await _loginLogic.getUserRole();

    if (role == "Attendee") {
      emit(UserHomescreenState(
          userHomeScreenRoute: attendeeHomeScreenPageRoute));
    } else {
      emit(
          UserHomescreenState(userHomeScreenRoute: managerHomeScreenPageRoute));
    }
  }
}
