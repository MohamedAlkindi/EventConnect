import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/attendee/my_events/business_logic/my_events_bl.dart';
import 'package:meta/meta.dart';

part 'my_events_state.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  MyEventsCubit() : super(MyEventsInitial());
  final MyEventsBL _myEventsBL = MyEventsBL();

  // Stream controller for real-time event updates
  final StreamController<List<EventModel>> _eventsStreamController =
      StreamController<List<EventModel>>.broadcast();
  Stream<List<EventModel>> get eventsStream => _eventsStreamController.stream;

  List<EventModel> _events = [];

  @override
  Future<void> close() {
    _eventsStreamController.close();
    return super.close();
  }

  Future<void> getAllEventsByUserID() async {
    emit(MyEventsLoading());
    try {
      List<EventModel> allEvents = await _myEventsBL.getAllEventsByUserID();
      _events = allEvents;

      // Update stream for real-time listeners
      _eventsStreamController.add(_events);

      // To show something else in the Bloc Builder.
      if (allEvents.isEmpty) {
        emit(MyEventsNoEventsAddedYet());
      } else {
        emit(MyEventsGotEvents(events: allEvents));
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
      await getAllEventsByUserID();
      emit(MyEventsDeletedEvent());
    } catch (e) {
      emit(MyEventsError(message: e.toString()));
    }
  }
}
