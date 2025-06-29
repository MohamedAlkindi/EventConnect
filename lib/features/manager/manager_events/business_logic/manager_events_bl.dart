import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/manager/manager_events/data_access/manager_events_da.dart';
import 'package:event_connect/shared/event_repo.dart';
import 'package:event_connect/shared/image_storage_service.dart';

class ManagerEventsBl {
  final _dataAccess = ManagerEventsDa();
  final _eventRepo = EventRepo();
  final _user = FirebaseUser();
  final _storageService = ImageStorageService();

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

  Future<void> addEvent(
      {required String name,
      required String category,
      required String picturePath,
      required String location,
      required String dateAndTime,
      required String description,
      required String genderRestriction}) async {
    try {
      var eventModel = EventModel(
        null,
        name: name,
        category: category,
        picture: await _storageService.addAndReturnImageUrl(
            imagePath: picturePath,
            eventName: name,
            userID: _user.getUserID,
            isEventPic: true),
        location: location,
        dateAndTime: dateAndTime,
        description: description,
        genderRestriction: genderRestriction,
        managerID: _user.getUserID,
      );

      await _dataAccess.addEvent(eventModel);
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> editEvent(
      {required String docID,
      required String name,
      required String category,
      required String supabaseImageUrl,
      required String? picturePath,
      required String location,
      required String dateAndTime,
      required String description,
      required String genderRestriction}) async {
    try {
      var updatedEvent = EventModel(
        null,
        name: name,
        category: category,
        // check if the picturePath sent from the cubit is not null
        // if it does then the user didnt change the picture so save the supabaseImageUrl in firestore.
        // otherwise if it doesnt then the user changed the picture.
        // so send the path and supabase link to update and get the url again.
        picture: picturePath == null
            ? supabaseImageUrl
            : await _storageService.updateAndReturnImageUrl(
                imageUrl: supabaseImageUrl,
                newImagePath: picturePath!,
                isEventPic: true,
              ),
        location: location,
        dateAndTime: dateAndTime,
        description: description,
        genderRestriction: genderRestriction,
        managerID: _user.getUserID,
      );
      await _dataAccess.editEvent(docID, updatedEvent);
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
