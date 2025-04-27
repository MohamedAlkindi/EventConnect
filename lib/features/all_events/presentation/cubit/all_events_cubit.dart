import 'package:bloc/bloc.dart';
import 'package:event_connect/features/all_events/business_logic/all_events_bl.dart';
import 'package:meta/meta.dart';

part 'all_events_state.dart';

class AllEventsCubit extends Cubit<AllEventsState> {
  AllEventsCubit() : super(AllEventsInitial());

  final AllEventScreenBL _businessLogic = AllEventScreenBL();

  // Use Streams to update the events list after adding an event.

  // Show all events.
  Future<void> getAllEvents() async {
    // emit(AllEventsLoading());
    try {
      List<Map<String, dynamic>> allEvents = await _businessLogic.getEvents();

      // To show something else in the Bloc Builder.
      if (allEvents.isEmpty) {
        emit(AllEventsNoEventsYet());
      } else {
        emit(AllEventsGotEvents(events: allEvents));
      }
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // Show events by category.
  Future<void> getEventsByCategory({required String category}) async {
    // emit(AllEventsLoading());
    try {
      List<Map<String, dynamic>> eventsByCat =
          await _businessLogic.getEventsByCategory(category: category);
      if (eventsByCat.isEmpty) {
        emit(AllEventsNoEventsYet());
      } else {
        emit(AllEventsGotEvents(events: eventsByCat));
      }
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // Add events to user's events.
  Future<void> addEventToUserEvents({required int eventID}) async {
    // emit(AllEventsLoading());
    try {
      await _businessLogic.addEventToUserEvents(eventID);
      emit(EventAddedToUserEvents());

      // Refresh the events list after adding an event
      await getAllEvents();
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }
}
