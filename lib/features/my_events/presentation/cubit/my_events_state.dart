part of 'my_events_cubit.dart';

@immutable
sealed class MyEventsState {}

final class MyEventsInitial extends MyEventsState {}

final class MyEventsLoading extends MyEventsState {}

final class MyEventsGotEvents extends MyEventsState {
  final List<Map<String, dynamic>> events;

  MyEventsGotEvents({required this.events});
}

final class MyEventsNoEventsAddedYet extends MyEventsState {}

final class MyEventsDeletedEvent extends MyEventsState {}

final class MyEventsError extends MyEventsState {
  final String message;

  MyEventsError({required this.message});
}
