import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/attendee/all_events/data_access/all_events_da.dart';
import 'package:event_connect/shared/event_repo.dart';
import 'package:event_connect/shared/image_caching_setup.dart';
import 'package:event_connect/shared/weather_setup.dart';

class AllEventScreenBL {
  final _dataAccess = AllEventsDa();
  final _eventRepo = EventRepo();
  final _imageCaching = ImageCachingSetup();
  final _weatherSetup = WeatherSetup();

  Future<List<EventModel>> getEvents() async {
    try {
      final allEventsSnapshot = await _eventRepo.getAllEventsSnapshot();
      // return an empty list to indicate that there're no events.
      if (allEventsSnapshot.docs.isEmpty) return [];

      final userEventsSnapshot = await _eventRepo.getUserEventsSnapshot();

      // Extract joined event IDs
      final joinedEventIds = userEventsSnapshot.docs.isEmpty
          ? []
          : userEventsSnapshot.docs
              .map(
                  (doc) => doc[EventsCollection.eventIDDocumentName] as String?)
              .whereType<String>()
              .toList();

      // Filter events
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

      await _imageCaching.downloadAndCacheImages(
          availableEventModels); // Await and use new method
      _weatherSetup.setupWeather(availableEventModels);
      return availableEventModels;
    } catch (e) {
      throw GenericException(ExceptionMessages.apiError);
    }
  }

  Future<void> addEventToUserEvents(String eventDocumentID) async {
    try {
      await _dataAccess.addEventToUserEvents(eventDocumentID);
    } catch (e) {
      throw GenericException(ExceptionMessages.addEventError);
    }
  }
}
