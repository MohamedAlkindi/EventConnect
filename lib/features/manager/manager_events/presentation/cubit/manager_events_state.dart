part of 'manager_events_cubit.dart';

@immutable
sealed class ManagerEventsState {}

final class ManagerEventsInitial extends ManagerEventsState {}

final class ManagerEventsLoading extends ManagerEventsState {}

final class EventDeletedSuccessfully extends ManagerEventsState {}

final class ManagerEventsError extends ManagerEventsState {
  final String message;

  ManagerEventsError({required this.message});
}
