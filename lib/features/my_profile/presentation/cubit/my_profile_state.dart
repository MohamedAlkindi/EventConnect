part of 'my_profile_cubit.dart';

@immutable
sealed class MyProfileState {}

final class MyProfileInitial extends MyProfileState {}

final class GotMyProfileInfo extends MyProfileState {
  final UserModel userInfo;

  GotMyProfileInfo({required this.userInfo});
}

final class UserDeletedSuccessfully extends MyProfileState {}

final class UserSignedOutSuccessfully extends MyProfileState {}

final class MyProfileError extends MyProfileState {
  final String message;

  MyProfileError({required this.message});
}
