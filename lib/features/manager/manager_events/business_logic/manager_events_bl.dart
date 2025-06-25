import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/manager/manager_events/data_access/manager_events_da.dart';
import 'package:event_connect/shared/event_repo.dart';

class ManagerEventsBl {
  final _dataAccess = ManagerEventsDa();
  final _eventRepo = EventRepo();

  Future<List<EventModel>> getEvents() async {
    try {
      var result = await _eventRepo.getManagerEvents();
      if (result.docs.isEmpty) return [];

      final managerEvents = result.docs
          .map((doc) {
            final data = doc.data();
            return EventModel.fromJson({
              ...data,
              EventsCollection.eventIDDocumentName: doc.id,
            });
          })
          .whereType<EventModel>()
          .toList();

      return managerEvents;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> deleteEvent({required String documentID}) async {
    try {
      await _dataAccess.deleteManagerEvent(documentID);
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
