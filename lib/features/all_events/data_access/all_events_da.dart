import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_events_collection_documents.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class AllEventsDa {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<void> addEventToUserEvents(String eventDocumentID) async {
    try {
      final customDocID = "${_user.getUserID}_$eventDocumentID";
      await _firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .doc(customDocID)
          .set({
        UserEventsCollection.userIDDocumentName: _user.getUserID,
        UserEventsCollection.eventIDDocumentName: eventDocumentID,
      });
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
