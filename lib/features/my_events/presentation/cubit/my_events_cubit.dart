import 'package:bloc/bloc.dart';
import 'package:event_connect/features/my_events/business_logic/my_events_ba.dart';
import 'package:meta/meta.dart';

part 'my_events_state.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  MyEventsCubit() : super(MyEventsInitial());
  final MyEventsBA _myEventsBA = MyEventsBA();

  Future<void> getAllEventsByUserID() async {
    emit(MyEventsLoading());
    try {
      List<Map<String, dynamic>> allEvents =
          await _myEventsBA.getAllEventsByUserID();

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
  Future<void> deleteEventFromUserEvents({required int eventID}) async {
    try {
      await _myEventsBA.deleteEventFromUserEvents(eventID);
      emit(MyEventsDeletedEvent());
      // Refresh the events list after deleting
      await getAllEventsByUserID();
    } catch (e) {
      emit(MyEventsError(message: e.toString()));
    }
  }
}
