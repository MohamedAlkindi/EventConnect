import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/service/image_compression_service.dart';
import 'package:event_connect/core/service/image_storage_service.dart';
import 'package:event_connect/features/manager/manager_events/data_access/manager_events_da.dart';
import 'package:event_connect/shared/event_repo.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class ManagerEventsBl {
  final _dataAccess = ManagerEventsDa();
  final _eventRepo = EventRepo();
  final _userID = FirebaseUser().getUserID;
  final _imageCompression = ImageCompressionService();
  final _imageCaching = ImageCachingSetup();
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
      await _imageCaching.downloadAndCacheImages(managerEvents);
      return managerEvents;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> deleteEvent({required String documentID}) async {
    try {
      await _dataAccess.deleteManagerEvent(documentID);
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

// Return a model to put it in the cubit stream later.
  Future<EventModel> addEvent(
      {required String name,
      required String category,
      required String picturePath,
      required String location,
      required String dateAndTime,
      required String description,
      required String genderRestriction}) async {
    try {
      final String imagePath =
          await _imageCompression.compressAndReplaceImage(picturePath);
      // Prepare the event model to add it to the firestore.
      var eventModel = EventModel(
        // EventID is null because we havent yet added it so we can use it in the model.
        eventID: null,
        // Picture is also null
        name: name,
        category: category,
        pictureUrl: await _storageService.addAndReturnImageUrl(
          imagePath: imagePath,
          eventName: name,
          userID: _userID,
          isEventPic: true,
        ),
        location: location,
        dateAndTime: dateAndTime,
        description: description,
        genderRestriction: genderRestriction,
        managerID: _userID, cachedPicturePath: null,
      );

      // get the document id and put it in the event model, and return it,
      // to be used later in the cubit to add it to the stream.
      String modelId = await _dataAccess.addEvent(eventModel);
      eventModel.eventID = modelId;
      return eventModel;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  // similar work to add event, but this time the docID is already here.
  Future<EventModel> editEvent({
    required String docID,
    required String name,
    required String category,
    required String supabaseImageUrl,
    required String? picturePath,
    required String location,
    required String dateAndTime,
    required String description,
    required String genderRestriction,
  }) async {
    try {
      final String? imagePath = picturePath != null
          ? await _imageCompression.compressAndReplaceImage(picturePath)
          : null;
      var updatedEvent = EventModel(
        eventID: docID,
        name: name,
        category: category,
        // check if the picturePath sent from the cubit is not null
        // if it does then the user didnt change the picture so save the supabaseImageUrl in firestore.
        // otherwise the user has changed the picture.
        // so send the path and supabase link to update and get the url again.
        pictureUrl: imagePath == null
            ? supabaseImageUrl
            : await _storageService.updateAndReturnImageUrl(
                eventImageUrl: supabaseImageUrl,
                newImagePath: imagePath,
                isEventPic: true,
                userID: null,
              ),
        location: location,
        dateAndTime: dateAndTime,
        description: description,
        genderRestriction: genderRestriction,
        managerID: _userID, cachedPicturePath: imagePath,
      );
      await _dataAccess.editEvent(updatedEvent);
      return updatedEvent;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
