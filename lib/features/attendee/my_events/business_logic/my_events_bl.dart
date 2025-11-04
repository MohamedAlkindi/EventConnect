import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/attendee/my_events/data_access/my_events_da.dart';
import 'package:event_connect/shared/event_repo.dart';
import 'package:event_connect/shared/image_caching_setup.dart';
import 'package:event_connect/shared/weather_setup.dart';

class MyEventsBL {
  final _dataAccess = MyEventsDa();
  final eventRepo = EventRepo();
  final _imageCaching = ImageCachingSetup();
  // final _weatherSetup = WeatherSetup();

  Future<List<EventModel>> getAllEventsByUserID() async {
    try {
      final userEventsSnapshot = await eventRepo.getUserEventsSnapshot();
      // return an empty list to indicate that there's no user events.
      if (userEventsSnapshot.docs.isEmpty) return [];

      final allEventsSnapshot = await eventRepo.getAllEventsSnapshot();

      // Extract joined event IDs
      final joinedEventIds = userEventsSnapshot.docs
          .map((doc) => doc[EventsCollection.eventIDDocumentName] as String?)
          .whereType<String>()
          .toList();

      // Filter events
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
      await _imageCaching.downloadAndCacheImages(userEvents);
      // Inject weather asynchronously
      // await _weatherSetup.setupWeather(userEvents);
      return userEvents;
    } catch (e) {
      throw GenericException(ExceptionMessages.apiError);
    }
  }

  Future<void> deleteEventFromUserEvents(String documentID) async {
    try {
      await _dataAccess.deleteEventFromUserEvents(documentID);
    } catch (e) {
      throw GenericException("Error:: ${e.toString()}");
    }
  }
}
