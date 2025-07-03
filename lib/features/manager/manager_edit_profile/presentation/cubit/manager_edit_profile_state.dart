part of 'manager_edit_profile_cubit.dart';

@immutable
sealed class ManagerEditProfileState {}

final class ManagerEditProfileInitial extends ManagerEditProfileState {}

final class ManagerEditProfileLoading extends ManagerEditProfileState {}

final class ManagerEditProfileSuccess extends ManagerEditProfileState {}

final class SelectedCity extends ManagerEditProfileState {
  final String selectedCity;
  SelectedCity({required this.selectedCity});
}

final class SelectedImage extends ManagerEditProfileState {
  final String selectedImagePath;

  SelectedImage({required this.selectedImagePath});
}

final class GotManagerProfile extends ManagerEditProfileState {
  final UserModel managerProfile;
  GotManagerProfile({required this.managerProfile});
}

final class ManagerEditProfileError extends ManagerEditProfileState {
  final String message;
  ManagerEditProfileError({required this.message});
}
