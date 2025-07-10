part of 'edit_event_cubit.dart';

@immutable
sealed class EditEventState {}

final class EditEventInitial extends EditEventState {}

final class EventUpdateLoading extends EditEventState {}

final class EventUpdatedSuccessfully extends EditEventState {}

final class SelectedCategory extends EditEventState {
  final String selectedCategory;

  SelectedCategory({required this.selectedCategory});
}

final class SelectedLocation extends EditEventState {
  final String selectedLocation;

  SelectedLocation({required this.selectedLocation});
}

final class SelectedGenderRestriction extends EditEventState {
  final String selectedGenderRestriction;

  SelectedGenderRestriction({required this.selectedGenderRestriction});
}

final class SelectedImage extends EditEventState {
  final String selectedImagePath;

  SelectedImage({required this.selectedImagePath});
}

final class EditEventError extends EditEventState {
  final String message;

  EditEventError({required this.message});
}
