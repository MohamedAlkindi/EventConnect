import 'package:bloc/bloc.dart';
import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/features/email_confirmation/business_logic/email_cofirmation_logic.dart';
import 'package:meta/meta.dart';

part 'email_confirmation_state.dart';

class EmailConfirmationCubit extends Cubit<EmailConfirmationState> {
  EmailConfirmationCubit() : super(EmailConfirmationInitial());
  final _confirmationLogic = EmailCofirmationLogic();

  Future<void> sendEmailConfirmation() async {
    try {
      emit(LoadingState());
      await _confirmationLogic.sendEmailConfirmation();
      emit(EmailSentState());
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> isEmailConfirmed() async {
    try {
      emit(LoadingState());
      emit(EmailConfirmed(
          isConfirmed: await _confirmationLogic.isEmailConfirmed()));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void isDataCompleted() async {
    try {
      emit(LoadingState());
      emit(DataCompleted(
          isDataCompleted: await _confirmationLogic.isDataCompleted()));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  // Based on role..
  void showUserHomescreen() async {
    final role = await _confirmationLogic.getUserRole();

    if (role == "Attendee") {
      emit(UserHomescreenState(
          userHomeScreenPageRoute: attendeeHomeScreenPageRoute));
    } else {
      emit(UserHomescreenState(
          userHomeScreenPageRoute: managerHomeScreenPageRoute));
    }
  }
}
