import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/features/all_events/business_logic/all_events_bl.dart';
import 'package:meta/meta.dart';

part 'all_events_state.dart';

class AllEventsCubit extends Cubit<AllEventsState> {
  AllEventsCubit() : super(AllEventsInitial());

  final AllEventScreenBL _businessLogic = AllEventScreenBL();

  // Stream controller for real-time event updates
  final StreamController<List<Map<String, dynamic>>> _eventsStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
      
  // Expose the stream to listen for real-time updates
  Stream<List<Map<String, dynamic>>> get eventsStream =>
      _eventsStreamController.stream;

  List<Map<String, dynamic>> _allEvents = [];

  @override
  Future<void> close() {
    _eventsStreamController.close();
    return super.close();
  }

  // Show all events.
  Future<void> getAllEvents() async {
    emit(AllEventsLoading());
    try {
      List<Map<String, dynamic>> allEvents = await _businessLogic.getEvents();
      _allEvents = allEvents;
      // Update stream for real-time listeners
      _eventsStreamController.add(_allEvents);

      // Update UI state
      if (allEvents.isEmpty) {
        emit(AllEventsNoEventsYet());
      } else {
        emit(AllEventsGotEvents(events: _allEvents));
      }
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // Show events by category.
  Future<void> getEventsByCategory({required String category}) async {
    emit(AllEventsLoading());
    try {
      final filteredEvents = category == "All"
          ? _allEvents
          : _allEvents
              .where((event) =>
                  event[EventsTable.eventCategoryColumnName] == category)
              .toList();

      // Update stream for real-time listeners
      _eventsStreamController.add(filteredEvents);

      if (filteredEvents.isEmpty) {
        emit(AllEventsNoEventsYet());
      } else {
        emit(AllEventsGotEvents(events: filteredEvents));
      }
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // Add events to user's events.
  Future<void> addEventToUserEvents({required int eventID}) async {
    emit(AllEventsLoading());
    try {
      await _businessLogic.addEventToUserEvents(eventID);

      // Remove the event from the local list
      _allEvents.removeWhere(
          (event) => event[EventsTable.eventIDColumnName] == eventID);

      // Update stream with the new list
      _eventsStreamController.add(_allEvents);

      // Update UI state
      if (_allEvents.isEmpty) {
        emit(AllEventsNoEventsYet());
      } else {
        emit(AllEventsGotEvents(events: _allEvents));
      }

      emit(EventAddedToUserEvents());
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }
}
