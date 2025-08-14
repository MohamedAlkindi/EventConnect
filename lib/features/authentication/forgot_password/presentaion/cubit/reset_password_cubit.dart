import 'package:bloc/bloc.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions/firebase_exceptions/firebase_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/features/authentication/forgot_password/business_logic/firebase_password_reset.dart';
import 'package:flutter/material.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  final _firebasePasswordReset = FirebasePasswordReset();

  Future<void> resetPassword({
    required TextEditingController emailController,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await _firebasePasswordReset.sendPasswordResetEmail(emailController.text);
      emit(ResetPasswordEmailSend());
    } catch (e) {
      String messageId = ExceptionMessages.genericExceptionMessage;

      // Check for known custom exceptions with a message property
      if (e is EmptyFieldException) {
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
      emit(ResetPasswordError(message: messageId));
    }
  }
}
