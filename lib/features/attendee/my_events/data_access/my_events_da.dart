import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/user_events_collection_documents.dart';
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
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
