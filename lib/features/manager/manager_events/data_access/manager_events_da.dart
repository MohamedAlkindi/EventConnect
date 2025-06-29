import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/models/event_model.dart';

class ManagerEventsDa {
  final _firestore = FirebaseFirestore.instance;

  Future<void> deleteManagerEvent(String documentID) async {
    try {
      await _firestore
          .collection(EventsCollection.eventCollectionName)
          .doc(documentID)
          .delete();
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> addEvent(EventModel eventModel) async {
    try {
      await _firestore
          .collection(EventsCollection.eventCollectionName)
          .add(eventModel.toJson());
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  Future<void> editEvent(String docID, EventModel eventModel) async {
    try {
      await _firestore
          .collection(EventsCollection.eventCollectionName)
          .doc(docID)
          .update(eventModel.toJson());
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
