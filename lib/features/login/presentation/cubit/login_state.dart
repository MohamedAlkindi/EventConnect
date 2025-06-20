part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccessful extends LoginState {}

final class PasswordVisible extends LoginState {
  final bool currentVisibility;

  PasswordVisible({required this.currentVisibility});
}

final class EmailConfirmed extends LoginState {
  final bool isConfirmed;

  EmailConfirmed({required this.isConfirmed});
}

final class DataCompleted extends LoginState {
  final bool isDataCompleted;

  DataCompleted({required this.isDataCompleted});
}

final class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}
