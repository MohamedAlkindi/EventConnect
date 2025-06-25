import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/core/collections/events_collection_documents.dart';

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
}
