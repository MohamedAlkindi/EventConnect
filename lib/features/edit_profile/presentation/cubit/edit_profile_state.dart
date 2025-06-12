part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {}

final class GotUserProfile extends EditProfileState {
  final UserModel userProfile;
  GotUserProfile({required this.userProfile});
}

final class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError({required this.message});
}
