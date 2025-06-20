part of 'email_confirmation_cubit.dart';

@immutable
sealed class EmailConfirmationState {}

final class EmailConfirmationInitial extends EmailConfirmationState {}

final class EmailSentState extends EmailConfirmationState {}

final class EmailConfirmed extends EmailConfirmationState {
  final bool isConfirmed;

  EmailConfirmed({required this.isConfirmed});
}

final class DataCompleted extends EmailConfirmationState {
  final bool isDataCompleted;

  DataCompleted({required this.isDataCompleted});
}

final class ErrorState extends EmailConfirmationState {
  final String message;

  ErrorState({required this.message});
}
