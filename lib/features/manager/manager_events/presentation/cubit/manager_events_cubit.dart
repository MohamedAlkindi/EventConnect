import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/manager/manager_events/business_logic/manager_events_bl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'manager_events_state.dart';

class ManagerEventsCubit extends Cubit<ManagerEventsState> {
  ManagerEventsCubit() : super(ManagerEventsInitial());

  final _businessLogic = ManagerEventsBl();

  // Start of cubit for show events.
  // Stream controller for real-time event updates
  final BehaviorSubject<List<EventModel>> _eventsSubject =
      BehaviorSubject<List<EventModel>>();

  // Expose the stream to listen for real-time updates
  Stream<List<EventModel>> get eventsStream => _eventsSubject.stream;

  List<EventModel> _managerEvents = [];

  @override
  Future<void> close() {
    _eventsSubject.close();
    return super.close();
  }

  // Show all manager's events.
  Future<void> getAllEvents({required bool forceRefresh}) async {
    emit(ManagerEventsLoading());
    try {
      if (_managerEvents.isEmpty || forceRefresh) {
        List<EventModel> allEvents = await _businessLogic.getEvents();
        _managerEvents = allEvents;
      }
      // Update stream for real-time listeners
      _eventsSubject.add(List<EventModel>.from(_managerEvents));
    } catch (e) {
      emit(ManagerEventsError(message: e.toString()));
    }
  }
  // End of cubit for show events.

  // Start of cubit to delete events.
  Future<void> deleteEvent({required String documentID}) async {
    emit(ManagerEventsLoading());
    try {
      await _businessLogic.deleteEvent(documentID: documentID);
      _managerEvents.removeWhere((event) => event.eventID == documentID);
      _eventsSubject
          .add(List<EventModel>.from(_managerEvents)); // Emit a new list
      emit(EventDeletedSuccessfully());
    } catch (e) {
      emit(ManagerEventsError(message: e.toString()));
    }
  }
  // End of cubit to delete events.

  Future<void> refreshManagerEvents() async {
    await getAllEvents(forceRefresh: true);
  }

  // Instead of making the stream public, i'll use these methods to do my actions to the stream.
  void addEventToStream(EventModel event) {
    _managerEvents.add(event);
    _eventsSubject
        .add(List<EventModel>.from(_managerEvents)); // Emit a new list
  }

  void editEventInStream(EventModel event) {
    final index = _managerEvents.indexWhere((e) => e.eventID == event.eventID);
    if (index != -1) {
      _managerEvents[index] = event;
      _eventsSubject
          .add(List<EventModel>.from(_managerEvents)); // Emit a new list
    }
  }
}
