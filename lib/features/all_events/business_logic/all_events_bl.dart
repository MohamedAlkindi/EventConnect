import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/service/api_service.dart';

class AllEventScreenBL {
  final ApiService apiService = ApiService();
  final firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  DateTime getDate(String dateTime) {
    final date = dateTime.split(' ')[0];
    return DateTime.parse(date);
  }

  Future<List<EventModel>> getEvents() async {
    try {
      // var events = await _dataAccess.getAllEvents();
      // Get all user's events based on their user ID.
      final userEventsDocs = await firestore
          .collection('user_events')
          .where(
            'userID',
            isEqualTo: _user.getUserID,
          )
          .get();

      // Group them by the event id.
      final joinedEventIds = userEventsDocs.docs
          .map(
            (doc) => doc['eventID'],
          )
          .toList();

      // Lastly filter the all events based on the previous two.
      final allEvents = await firestore.collection('events').get();

      final availableEvents = allEvents.docs.where((eventDoc) {
        return !joinedEventIds.contains(eventDoc.id);
      }).toList();

      final availableEventModels = availableEvents.map((doc) {
        final data = doc.data();
        return EventModel.fromJson({
          ...data,
          'eventID': doc.id,
        });
      }).toList();

      for (var event in availableEventModels) {
        event.weather = await apiService.getWeatherForDate(
          date: getDate(event.dateAndTime),
          location: event.location,
        );
      }

      return availableEventModels;
    } catch (e) {
      throw GenericException(message: ExceptionMessages.apiError);
    }
  }

  Future<void> addEventToUserEvents(int eventID) async {
    try {
      // await _dataAccess.addEventToUserEvents(eventID);
    } catch (e) {
      throw GenericException(message: ExceptionMessages.addEventError);
    }
  }
}
