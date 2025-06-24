part of 'email_confirmation_cubit.dart';

@immutable
sealed class EmailConfirmationState {}

final class EmailConfirmationInitial extends EmailConfirmationState {}

final class LoadingState extends EmailConfirmationState {}

final class EmailSentState extends EmailConfirmationState {}

final class EmailConfirmed extends EmailConfirmationState {
  final bool isConfirmed;

  EmailConfirmed({required this.isConfirmed});
}

final class DataCompleted extends EmailConfirmationState {
  final bool isDataCompleted;

  DataCompleted({required this.isDataCompleted});
}

final class UserHomescreenState extends EmailConfirmationState {
  final String userHomeScreenPageRoute;

  UserHomescreenState({required this.userHomeScreenPageRoute});
}

final class ErrorState extends EmailConfirmationState {
  final String message;

  ErrorState({required this.message});
}
