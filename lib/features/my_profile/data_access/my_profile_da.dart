import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

class MyProfileDA {
  final Database _db = AppDatabase.db;
  final FirebaseUser _user = FirebaseUser();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getUserPicAndName() async {
    final result = await _db.query(
      UserTable.userTableName,
      columns: [
        UserTable.userProfilePicColumnName,
        UserTable.userNameColumnName,
      ],
      where: '${UserTable.userIDColumnName} = ?',
      whereArgs: [_user.getUserID],
    );
    return result.first;
  }

  Future<void> deleteUser() async {
    await _db.delete(
      UserTable.userTableName,
      where: '${UserTable.userIDColumnName} = ?',
      whereArgs: [_user.getUserID],
    );
    await _auth.currentUser?.delete();
  }
}
