part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccessful extends RegisterState {}

final class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState({required this.message});
}
