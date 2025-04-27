import 'package:event_connect/features/my_events/data_access/my_events_da.dart';

class MyEventsBL {
  final MyEventsDA _myEventsDA = MyEventsDA();

  Future<List<Map<String, dynamic>>> getAllEventsByUserID() async {
    return await _myEventsDA.getAllEventsByUserID();
  }

  Future<void> deleteEventFromUserEvents(int eventID) async {
    await _myEventsDA.deleteEventFromUserEvents(eventID);
  }
}
