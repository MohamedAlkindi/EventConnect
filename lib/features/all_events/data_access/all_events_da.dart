import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/tables/events_table.dart';
import 'package:sqflite/sqflite.dart';

class AllEventScreenDA {
  final Database _db = AppDatabase.db;

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    return await _db.query(EventsTable.eventTableName);
  }

  Future<List<Map<String, dynamic>>> getEventsByCategory(
      {required String category}) async {
    return await _db.query(EventsTable.eventTableName,
        where: '${EventsTable.eventCategoryColumnName} = ?',
        whereArgs: [category]);
  }
}
