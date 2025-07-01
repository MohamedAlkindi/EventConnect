import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/attendee/my_events/business_logic/my_events_bl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'my_events_state.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  MyEventsCubit() : super(MyEventsInitial());
  final MyEventsBL _myEventsBL = MyEventsBL();

  // Stream controller for real-time event updates
  final BehaviorSubject<List<EventModel>> _eventsSubject =
      BehaviorSubject<List<EventModel>>();
  Stream<List<EventModel>> get eventsStream => _eventsSubject.stream;

  List<EventModel> _events = [];

  @override
  Future<void> close() {
    _eventsSubject.close();
    return super.close();
  }

  Future<void> getAllEventsByUserID({required bool forceRefresh}) async {
    emit(MyEventsLoading());
    try {
      if (_events.isEmpty || forceRefresh) {
        List<EventModel> allEvents = await _myEventsBL.getAllEventsByUserID();
        _events = allEvents;
      }

      // Update stream for real-time listeners
      _eventsSubject.add(_events);

      // To show something else in the Bloc Builder.
      if (_events.isEmpty) {
        emit(MyEventsNoEventsAddedYet());
      } else {
        emit(MyEventsGotEvents(events: _events));
      }
    } catch (e) {
      emit(MyEventsError(message: e.toString()));
    }
  }

  // Delete event from user's events.
  Future<void> deleteEventFromUserEvents({required String documentID}) async {
    try {
      await _myEventsBL.deleteEventFromUserEvents(documentID);
      // Refresh the events list after deleting
      // Remove the event from the local list
      _events.removeWhere((event) => event.eventID == documentID);

      // Update stream with the new list
      _eventsSubject.add(_events);
      emit(MyEventsDeletedEvent());
    } catch (e) {
      emit(MyEventsError(message: e.toString()));
    }
  }

  Future<void> forceRefreshEvents() async {
    await getAllEventsByUserID(forceRefresh: true);
  }
}
