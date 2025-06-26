part of 'add_event_cubit.dart';

@immutable
sealed class AddEventState {}

final class AddEventInitial extends AddEventState {}

final class ManagerEventsLoading extends AddEventState {}

final class EventAddedSuccessfully extends AddEventState {}

final class SelectedCategory extends AddEventState {
  final String selectedCategory;

  SelectedCategory({required this.selectedCategory});
}

final class SelectedLocation extends AddEventState {
  final String selectedLocation;

  SelectedLocation({required this.selectedLocation});
}

final class SelectedGenderRestriction extends AddEventState {
  final String selectedGenderRestriction;

  SelectedGenderRestriction({required this.selectedGenderRestriction});
}

final class SelectedImage extends AddEventState {
  final String selectedImagePath;

  SelectedImage({required this.selectedImagePath});
}

final class AddEventError extends AddEventState {
  final String message;

  AddEventError({required this.message});
}
