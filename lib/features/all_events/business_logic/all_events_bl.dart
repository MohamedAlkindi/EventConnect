import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/collections/user_events_collection_documents.dart';
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
      // Step 1: Get all events
      final allEventsSnapshot = await firestore
          .collection(EventsCollection.eventCollectionName)
          .get();
      if (allEventsSnapshot.docs.isEmpty) return [];

      // Step 2: Fetch user-event relationships
      final userEventsSnapshot = await firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .where(
            UserCollection.userIDDocumentName,
            isEqualTo: _user.getUserID,
          )
          .get();

      // Step 3: Extract joined event IDs
      final joinedEventIds = userEventsSnapshot.docs
          .map((doc) => doc[EventsCollection.eventIDDocumentName] as String?)
          .whereType<String>()
          .toList();

      // Step 4: Filter events
      final availableEventModels = joinedEventIds.isEmpty
          ? allEventsSnapshot.docs
              .map((doc) {
                final data = doc.data();
                return EventModel.fromJson({
                  ...data,
                  EventsCollection.eventIDDocumentName: doc.id,
                });
              })
              .whereType<EventModel>()
              .toList()
          : allEventsSnapshot.docs
              .where((doc) => !joinedEventIds.contains(doc.id))
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

  Future<void> addEventToUserEvents(String eventDocumentID) async {
    try {
      final customDocID = "${_user.getUserID}_$eventDocumentID";
      await firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .doc(customDocID)
          .set({
        UserEventsCollection.userIDDocumentName: _user.getUserID,
        UserEventsCollection.eventIDDocumentName: eventDocumentID,
      });
    } catch (e) {
      throw GenericException(message: ExceptionMessages.addEventError);
    }
  }
}
