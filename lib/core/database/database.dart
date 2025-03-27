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
}
