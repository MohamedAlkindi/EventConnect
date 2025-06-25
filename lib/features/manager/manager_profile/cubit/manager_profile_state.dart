part of 'manager_profile_cubit.dart';

@immutable
sealed class ManagerProfileState {}

final class ManagerProfileInitial extends ManagerProfileState {}

final class GotManagerProfileInfo extends ManagerProfileState {
  final UserModel userInfo;

  GotManagerProfileInfo({required this.userInfo});
}

final class ManagerDeletedSuccessfully extends ManagerProfileState {}

final class ManagerSignedOutSuccessfully extends ManagerProfileState {}

final class ManagerProfileError extends ManagerProfileState {
  final String message;

  ManagerProfileError({required this.message});
}
