import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/collections/user_collection_document.dart';
import 'package:event_connect/core/collections/user_events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class EventRepo {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseUser();

  Future<QuerySnapshot<Map<String, dynamic>>> getAllEventsSnapshot() async {
    try {
      return await _firestore
          .collection(EventsCollection.eventCollectionName)
          .get();
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserEventsSnapshot() async {
    try {
      return await _firestore
          .collection(UserEventsCollection.userEventsCollectionName)
          .where(
            UserCollection.userIDDocumentName,
            isEqualTo: _user.getUserID,
          )
          .get();
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getManagerEvents() async {
    try {
      return await _firestore
          .collection(EventsCollection.eventCollectionName)
          .where(
            EventsCollection.managerIdDocumentName,
            isEqualTo: _user.getUserID,
          )
          .get();
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }
}
