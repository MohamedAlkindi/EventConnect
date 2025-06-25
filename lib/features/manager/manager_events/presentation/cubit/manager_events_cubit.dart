import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/manager/manager_events/business_logic/manager_events_bl.dart';
import 'package:meta/meta.dart';

part 'manager_events_state.dart';

class ManagerEventsCubit extends Cubit<ManagerEventsState> {
  ManagerEventsCubit() : super(ManagerEventsInitial());

  final _businessLogic = ManagerEventsBl();

  // Stream controller for real-time event updates
  final StreamController<List<EventModel>> _eventsStreamController =
      StreamController<List<EventModel>>.broadcast();

  // Expose the stream to listen for real-time updates
  Stream<List<EventModel>> get eventsStream => _eventsStreamController.stream;

  List<EventModel> _managerEvents = [];

  @override
  Future<void> close() {
    _eventsStreamController.close();
    return super.close();
  }

  // Show all manager's events.
  Future<void> getAllEvents() async {
    emit(ManagerEventsLoading());
    try {
      List<EventModel> allEvents = await _businessLogic.getEvents();
      _managerEvents = allEvents;
      // Update stream for real-time listeners
      _eventsStreamController.add(_managerEvents);
    } catch (e) {
      emit(ManagerEventsError(message: e.toString()));
    }
  }

  // Add events to user's events.
  Future<void> deleteEvent({required String documentID}) async {
    emit(ManagerEventsLoading());
    try {
      await _businessLogic.deleteEvent(documentID: documentID);

      // Remove the event from the local list
      _managerEvents.removeWhere((event) => event.eventID == documentID);

      // Update stream with the new list
      _eventsStreamController.add(_managerEvents);

      emit(EventDeletedSuccessfully());
    } catch (e) {
      emit(ManagerEventsError(message: e.toString()));
    }
  }
}
