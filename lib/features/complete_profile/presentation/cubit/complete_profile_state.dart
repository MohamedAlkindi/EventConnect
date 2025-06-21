part of 'complete_profile_cubit.dart';

@immutable
sealed class CompleteProfileState {}

final class CompleteProfileInitial extends CompleteProfileState {}

final class CompleteProfileLoading extends CompleteProfileState {}

final class SelectedCity extends CompleteProfileState {
  final String selectedCity;
  SelectedCity({required this.selectedCity});
}

final class SelectedImage extends CompleteProfileState {
  final String selectedImagePath;

  SelectedImage({required this.selectedImagePath});
}

final class SelectedRole extends CompleteProfileState {
  final String selectedRole;

  SelectedRole({required this.selectedRole});
}

final class CompleteProfileSuccessul extends CompleteProfileState {}

final class CompleteProfileError extends CompleteProfileState {
  final String message;

  CompleteProfileError({required this.message});
}
