import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
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
      throw GenericException("Error: ${e.toString()}");
    }
  }

  Future<String> addEvent(EventModel eventModel) async {
    try {
      final docRef = await _firestore
          .collection(EventsCollection.eventCollectionName)
          .add(eventModel.toJson());
      return docRef.id;
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }

  Future<void> editEvent(EventModel eventModel) async {
    try {
      await _firestore
          .collection(EventsCollection.eventCollectionName)
          .doc(eventModel.eventID)
          .update(eventModel.toUpdateJson());
    } catch (e) {
      throw GenericException("Error: ${e.toString()}");
    }
  }
}
