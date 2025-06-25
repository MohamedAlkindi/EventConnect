part of 'user_homescreen_cubit.dart';

@immutable
class UserHomescreenState {
  final int currentIndex;
  final File? imageFile;

  const UserHomescreenState({
    this.currentIndex = 0,
    this.imageFile,
  });
}

final class UserHomescreenInitial extends UserHomescreenState {
  const UserHomescreenInitial() : super();
}

final class UserHomescreenLoading extends UserHomescreenState {
  const UserHomescreenLoading({super.currentIndex, super.imageFile});
}

final class GotUserProfilePic extends UserHomescreenState {
  final File imageFile;

  const GotUserProfilePic({required this.imageFile});
}

final class UserHomescreenError extends UserHomescreenState {
  final String message;

  const UserHomescreenError({
    required this.message,
    super.currentIndex,
    super.imageFile,
  });
}
