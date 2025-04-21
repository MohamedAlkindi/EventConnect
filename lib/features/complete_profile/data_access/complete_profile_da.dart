import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class CompleteProfileDa {
  final Database _db = AppDatabase.db;
  FirebaseUser user = FirebaseUser();

  Future<void> finalizeProfile(
      {required Map<String, dynamic> updatedData}) async {
    await _db.update(UserTable.userTableName, updatedData,
        where: '${UserTable.userIDColumnName} = ?',
        whereArgs: [
          user.userID,
        ]);
  }
}
