// import 'package:event_connect/core/database/database.dart';
// import 'package:event_connect/core/firebase/user/firebase_user.dart';
// import 'package:sqflite/sqflite.dart';

// class AllEventScreenDA {
//   final Database _db = AppDatabase.db;
//   final FirebaseUser _user = FirebaseUser();

//   // For All Events screen, to only show the events that the user has not joined yet,
//   //without adding the category filter.
//   Future<List<Map<String, dynamic>>> getAllEvents() async {
//     return await _db.rawQuery('''
//       SELECT * FROM ${EventsTable.eventTableName} 
//       WHERE ${EventsTable.eventIDColumnName} NOT IN (
//         SELECT ${UserEvents.eventIDColumnName} FROM ${UserEvents.userEventsTableName}
//       )
//     ''');
//   }

//   // For All Events screen, to only show the events that the user has not joined yet,
//   //adding the CATEGORY filter.
//   Future<List<Map<String, dynamic>>> getEventsByCategory(
//       {required String category}) async {
//     return await _db.rawQuery('''
//         SELECT * FROM ${EventsTable.eventTableName} 
//         WHERE ${EventsTable.eventCategoryColumnName} = ? AND
//         ${EventsTable.eventIDColumnName} NOT IN (
//           SELECT ${UserEvents.eventIDColumnName} FROM ${UserEvents.userEventsTableName}
//         )
//       ''', [category]);
//   }

//   // For All Events screen, to add the event to the user's events.
//   Future<void> addEventToUserEvents(int eventID) async {
//     await _db.insert(
//       UserEvents.userEventsTableName,
//       {
//         UserEvents.eventIDColumnName: eventID,
//         UserEvents.userIDColumnName: _user.getUserID,
//       },
//     );
//   }
// }
