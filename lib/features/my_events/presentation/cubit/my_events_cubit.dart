// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:event_connect/features/my_events/business_logic/my_events_bl.dart';
// import 'package:meta/meta.dart';

// part 'my_events_state.dart';

// class MyEventsCubit extends Cubit<MyEventsState> {
//   MyEventsCubit() : super(MyEventsInitial());
//   final MyEventsBL _myEventsBL = MyEventsBL();

//   // Stream controller for real-time event updates
//   final StreamController<List<Map<String, dynamic>>> _eventsStreamController =
//       StreamController<List<Map<String, dynamic>>>.broadcast();
//   Stream<List<Map<String, dynamic>>> get eventsStream =>
//       _eventsStreamController.stream;

//   List<Map<String, dynamic>> _events = [];

//   @override
//   Future<void> close() {
//     _eventsStreamController.close();
//     return super.close();
//   }

//   Future<void> getAllEventsByUserID() async {
//     emit(MyEventsLoading());
//     try {
//       List<Map<String, dynamic>> allEvents =
//           await _myEventsBL.getAllEventsByUserID();
//       _events = allEvents;

//       // Update stream for real-time listeners
//       _eventsStreamController.add(_events);

//       // To show something else in the Bloc Builder.
//       if (allEvents.isEmpty) {
//         emit(MyEventsNoEventsAddedYet());
//       } else {
//         emit(MyEventsGotEvents(events: allEvents));
//       }
//     } catch (e) {
//       emit(MyEventsError(message: e.toString()));
//     }
//   }

//   // Delete event from user's events.
//   Future<void> deleteEventFromUserEvents({required int eventID}) async {
//     try {
//       await _myEventsBL.deleteEventFromUserEvents(eventID);
//       emit(MyEventsDeletedEvent());
//       // Refresh the events list after deleting
//       await getAllEventsByUserID();
//     } catch (e) {
//       emit(MyEventsError(message: e.toString()));
//     }
//   }
// }
