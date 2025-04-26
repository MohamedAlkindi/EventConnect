import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AppDatabase {
  static late final Database db;
  static Future<void> initializeDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'EventsDatabase.db');
    bool dbExists = await databaseExists(path);
    if (!dbExists) {
      ByteData data =
          await rootBundle.load(join('assets/database', 'EventsDatabase.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    db = await openDatabase(path);
  }

  // static Future<void> initializeDB() async {
  //   String path = await _getDbPath();
  //   db = await openDatabase(path, version: 1, onCreate: _onCreate);
  // }

  // static void _onCreate(Database dbInstance, int version) async {
  //   final batch = dbInstance.batch();

  //   batch.execute(UserTable.createUserTable);
  //   batch.execute(EventsTable.createEventTable);
  //   batch.execute(UserEvents.createUserEventTable);

  //   await batch.commit(noResult: true);
  // }

  // static Future<String> _getDbPath() async {
  //   String path = await getDatabasesPath();
  //   return "$path/EventsDb.db";
  // }

  static Future<void> deleteDB() async {
    String path = await getDatabasesPath();
    await deleteDatabase("$path/EventsDatabase.db");
  }
}
