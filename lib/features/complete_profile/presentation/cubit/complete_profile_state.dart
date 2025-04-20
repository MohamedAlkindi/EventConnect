part of 'complete_profile_cubit.dart';

@immutable
sealed class CompleteProfileState {}

final class CompleteProfileInitial extends CompleteProfileState {}

final class CompleteProfileLoading extends CompleteProfileState {}

final class CompleteProfileSuccessul extends CompleteProfileState {}

final class CompleteProfileError extends CompleteProfileState {
  final String message;

  CompleteProfileError({required this.message});
}
