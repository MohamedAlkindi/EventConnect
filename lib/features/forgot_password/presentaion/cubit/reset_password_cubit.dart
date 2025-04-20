import 'package:bloc/bloc.dart';
import 'package:event_connect/features/forgot_password/business_logic/firebase_password_reset.dart';
import 'package:flutter/material.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  FirebasePasswordReset firebasePasswordReset = FirebasePasswordReset();

  Future<void> resetPassword({
    required TextEditingController emailController,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await firebasePasswordReset.sendPasswordResetEmail(emailController.text);
      emit(ResetPasswordEmailSend());
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }
}
