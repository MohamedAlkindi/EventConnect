import 'package:bloc/bloc.dart';
import 'package:event_connect/features/register/business_logic/firebase_register.dart';
import 'package:flutter/material.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  FirebaseRegister register = FirebaseRegister();

  Future<void> registerUser({
    required TextEditingController userName,
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController repeatPassword,
  }) async {
    try {
      emit(RegisterLoading());

      await register.createUser(
        email: email.text,
        password: password.text,
        repeatPassword: repeatPassword.text,
        userName: userName.text,
      );

      emit(RegisterSuccessful());
    } catch (e) {
      emit(RegisterErrorState(message: e.toString()));
    }
  }
}
