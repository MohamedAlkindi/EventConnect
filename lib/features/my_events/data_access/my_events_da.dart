// import 'package:event_connect/core/database/database.dart';
// import 'package:event_connect/core/firebase/user/firebase_user.dart';
// import 'package:event_connect/core/tables/user_events.dart';
// import 'package:event_connect/core/tables/events_table.dart';
// import 'package:sqflite/sqflite.dart';

// class MyEventsDA {
//   final Database _db = AppDatabase.db;
//   final FirebaseUser _user = FirebaseUser();

//   // Get all events added by user, using the user id.
//   Future<List<Map<String, dynamic>>> getAllEventsByUserID() async {
//     return await _db.rawQuery('''
//       SELECT 
//         e.${EventsTable.eventIDColumnName},
//         e.${EventsTable.eventNameColumnName},
//         e.${EventsTable.eventCategoryColumnName},
//         e.${EventsTable.eventPictureColumnName},
//         e.${EventsTable.eventLocationColumnName},
//         e.${EventsTable.eventDateTimeColumnName},
//         e.${EventsTable.eventDescriptionColumnName},
//         e.${EventsTable.eventGenderResrictionColumnName}
//       FROM ${UserEvents.userEventsTableName} ue
//       JOIN ${EventsTable.eventTableName} e 
//         ON ue.${UserEvents.eventIDColumnName} = e.${EventsTable.eventIDColumnName}
//       WHERE ue.${UserEvents.userIDColumnName} = ?
//     ''', [_user.getUserID]);
//   }

//   // Delete event from user's events.
//   Future<void> deleteEventFromUserEvents(int eventID) async {
//     await _db.delete(
//       UserEvents.userEventsTableName,
//       where:
//           '${UserEvents.eventIDColumnName} = ? AND ${UserEvents.userIDColumnName} = ?',
//       whereArgs: [eventID, _user.getUserID],
//     );
//   }
// }
