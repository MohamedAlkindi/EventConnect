part of 'manager_homescreen_cubit.dart';

@immutable
class ManagerHomescreenState {
  final int currentIndex;
  final String? imageFile;

  const ManagerHomescreenState({
    this.currentIndex = 0,
    this.imageFile,
  });
}

final class ManagerHomescreenInitial extends ManagerHomescreenState {
  const ManagerHomescreenInitial() : super();
}

final class ManagerHomescreenLoading extends ManagerHomescreenState {
  const ManagerHomescreenLoading({super.currentIndex, super.imageFile});
}

final class GotManagerProfilePic extends ManagerHomescreenState {
  final String imageFile;

  const GotManagerProfilePic({required this.imageFile});
}

final class ManagerHomescreenError extends ManagerHomescreenState {
  final String message;

  const ManagerHomescreenError({
    required this.message,
    super.currentIndex,
    super.imageFile,
  });
}
