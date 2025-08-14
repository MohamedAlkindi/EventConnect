import 'package:bloc/bloc.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/register/business_logic/firebase_register.dart';
import 'package:flutter/material.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit()
      : super(PasswordVisible(
          currentPasswordVisibility: true,
          currentRepeatPasswordVisibility: true,
        ));
  final _register = FirebaseRegister();

  Future<void> registerUser({
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController repeatPassword,
  }) async {
    emit(RegisterLoading());
    try {
      await _register.createUser(
        email: email.text,
        password: password.text,
        repeatPassword: repeatPassword.text,
      );
      emit(RegisterSuccessful());
    } catch (e) {
      String messageId = ExceptionMessages.genericExceptionMessage;

      // Check for known custom exceptions with a message property
      if (e is EmptyFieldException) {
        messageId = e.message;
      } else if (e is FirebaseCredentialsExceptions) {
        messageId = e.message;
      } else if (e is FirebaseWeakPass) {
        messageId = e.message;
      } else if (e is FirebaseEmailInUse) {
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
      emit(RegisterErrorState(message: messageId));
    }
  }

  void togglePasswordVisibility() {
    if (state is PasswordVisible) {
      final currentState = state as PasswordVisible;
      emit(
        PasswordVisible(
          currentPasswordVisibility: !currentState.currentPasswordVisibility,
          currentRepeatPasswordVisibility:
              currentState.currentRepeatPasswordVisibility,
        ),
      );
    }
  }

  void toggleRepeatPasswordVisibility() {
    if (state is PasswordVisible) {
      final currentState = state as PasswordVisible;
      emit(
        PasswordVisible(
          currentPasswordVisibility: currentState.currentPasswordVisibility,
          currentRepeatPasswordVisibility:
              !currentState.currentRepeatPasswordVisibility,
        ),
      );
    }
  }
}
