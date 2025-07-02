import 'package:bloc/bloc.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/email_confirmation/business_logic/email_cofirmation_logic.dart';
import 'package:event_connect/main.dart';
import 'package:meta/meta.dart';

part 'email_confirmation_state.dart';

class EmailConfirmationCubit extends Cubit<EmailConfirmationState> {
  EmailConfirmationCubit() : super(EmailConfirmationInitial());
  final _confirmation = EmailCofirmationLogic();
  final _user = FirebaseUser();

  Future<void> sendEmailConfirmation() async {
    try {
      emit(LoadingState());
      await _confirmation.sendEmailConfirmation();
      emit(EmailSentState());
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> isEmailConfirmed() async {
    try {
      emit(LoadingState());
      emit(EmailConfirmed(isConfirmed: await _confirmation.isEmailConfirmed()));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void isDataCompleted() async {
    try {
      emit(LoadingState());
      emit(DataCompleted(isDataCompleted: await _user.isUserDataCompleted()));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  // Based on role..
  void showUserHomescreen() async {
    final role = await _user.getUserRole();

    if (role == "Attendee") {
      emit(UserHomescreenState(
          userHomeScreenPageRoute: attendeeHomeScreenPageRoute));
    } else {
      emit(UserHomescreenState(
          userHomeScreenPageRoute: managerHomeScreenPageRoute));
    }
  }
}
