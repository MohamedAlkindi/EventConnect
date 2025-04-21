import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/core/tables/user_events.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static late final Database db;

  static Future<void> initializeDB() async {
    String path = await _getDbPath();
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static void _onCreate(Database dbInstance, int version) async {
    final batch = dbInstance.batch();

    batch.execute(UserTable.createUserTable);
    batch.execute(EventsTable.createEventTable);
    batch.execute(UserEvents.createUserEventTable);

    await batch.commit(noResult: true);
  }

  static Future<String> _getDbPath() async {
    String path = await getDatabasesPath();
    return "$path/EventsDb.db";
  }

  static Future<void> deleteDB() async {
    String path = await getDatabasesPath();
    await deleteDatabase("$path/EventsDb.db");
  }

  static Future<void> printDbValues() async {
    try {
      // Query all tables in the database
      List<Map<String, dynamic>> userTable =
          await db.query(UserTable.userTableName);
      List<Map<String, dynamic>> eventsTable =
          await db.query(EventsTable.eventTableName);
      List<Map<String, dynamic>> userEventsTable =
          await db.query(UserEvents.userEventsTableName);

      // Print the contents of each table
      print("User Table:");
      for (var row in userTable) {
        print(row);
      }

      print("\nEvents Table:");
      for (var row in eventsTable) {
        print(row);
      }

      print("\nUser Events Table:");
      for (var row in userEventsTable) {
        print(row);
      }
    } catch (e) {
      print("Error printing database values: $e");
    }
  }
}
