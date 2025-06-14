import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/collections/user_events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/service/api_service.dart';

class MyEventsBL {
  DateTime getDate(String dateTime) {
    final date = dateTime.split(' ')[0];
    return DateTime.parse(date);
  }

  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();
  final _apiService = ApiService();

  Future<List<EventModel>> getAllEventsByUserID() async {
    try {
      // Step 1: Get all events
      final allEventsSnapshot = await _firestore
          .collection(EventsCollection.eventCollectionName)
          .get();
      if (allEventsSnapshot.docs.isEmpty) return [];

      // Step 2: Fetch user-event relationships
      final userEventsSnapshot = await _firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .where(
            UserCollection.userIDDocumentName,
            isEqualTo: _user.getUserID,
          )
          .get();
      if (userEventsSnapshot.docs.isEmpty) return [];
      // Step 3: Extract joined event IDs
      final joinedEventIds = userEventsSnapshot.docs
          .map((doc) => doc[EventsCollection.eventIDDocumentName] as String?)
          .whereType<String>()
          .toList();

      // Step 4: Filter events
      final userEvents = joinedEventIds.isEmpty
          ? allEventsSnapshot.docs
              .map((doc) {
                return EventModel.fromJson({});
              })
              .whereType<EventModel>()
              .toList()
          : allEventsSnapshot.docs
              .where((doc) => joinedEventIds.contains(doc.id))
              .map((doc) {
                final data = doc.data();
                return EventModel.fromJson({
                  ...data,
                  EventsCollection.eventIDDocumentName: doc.id,
                });
              })
              .whereType<EventModel>()
              .toList();

      // Step 5: Inject weather asynchronously
      for (var event in userEvents) {
        event.weather = await _apiService.getWeatherForDate(
          date: getDate(event.dateAndTime),
          location: event.location,
        );
      }
      return userEvents;
    } catch (e) {
      throw GenericException(message: ExceptionMessages.apiError);
    }
  }

  Future<void> deleteEventFromUserEvents(String documentID) async {
    // await _myEventsDA.deleteEventFromUserEvents(eventID);
    try {
      final docId = "${_user.getUserID}_$documentID";

      await _firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
