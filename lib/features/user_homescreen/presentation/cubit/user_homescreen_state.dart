part of 'user_homescreen_cubit.dart';

@immutable
sealed class UserHomescreenState {}

final class UserHomescreenInitial extends UserHomescreenState {}

final class UserHomescreenLoading extends UserHomescreenState {}

final class UserSignedOutSuccessfully extends UserHomescreenState {}

final class GotUserProfilePic extends UserHomescreenState {
  final File imageFile;

  GotUserProfilePic({required this.imageFile});
}

final class UserHomescreenError extends UserHomescreenState {
  final String message;

  UserHomescreenError({required this.message});
}
