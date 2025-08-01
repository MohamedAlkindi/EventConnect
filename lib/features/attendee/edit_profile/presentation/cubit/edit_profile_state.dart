part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {}

final class SelectedCity extends EditProfileState {
  final String selectedCity;
  SelectedCity({required this.selectedCity});
}

final class SelectedImage extends EditProfileState {
  final String selectedImagePath;

  SelectedImage({required this.selectedImagePath});
}

final class GotUserProfile extends EditProfileState {
  final UserModel userProfile;
  GotUserProfile({required this.userProfile});
}

final class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError({required this.message});
}
