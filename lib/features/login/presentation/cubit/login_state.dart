part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccessfulWithData extends LoginState {}

final class LoginSuccessfulWithoutData extends LoginState {}

final class PasswordVisible extends LoginState {
  final bool currentVisibility;

  PasswordVisible({required this.currentVisibility});
}

final class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}
