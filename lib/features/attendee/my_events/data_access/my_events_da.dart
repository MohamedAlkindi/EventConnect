import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/collections/user_events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class MyEventsDa {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<void> deleteEventFromUserEvents(String documentID) async {
    try {
      final docId = "${_user.getUserID}_$documentID";

      await _firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .doc(docId)
          .delete();
      await decrementAttendees(documentID);
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }

  Future<void> decrementAttendees(String eventDocumentID) async {
    await _firestore
        .collection(EventsCollection.eventCollectionName)
        .doc(eventDocumentID)
        .update({
      EventsCollection.eventAttendeesDocumentName: FieldValue.increment(-1)
    });
  }
}
