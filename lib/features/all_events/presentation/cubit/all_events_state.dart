part of 'all_events_cubit.dart';

@immutable
sealed class AllEventsState {}

final class AllEventsInitial extends AllEventsState {}

final class AllEventsLoading extends AllEventsState {}

final class CategorySelected extends AllEventsState {
  final String category;

  CategorySelected({required this.category});
}

final class EventAddedToUserEvents extends AllEventsState {}

final class AllEventsLogOutSuccessful extends AllEventsState {}

final class AllEventsError extends AllEventsState {
  final String message;

  AllEventsError({required this.message});
}
