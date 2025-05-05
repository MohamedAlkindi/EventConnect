import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class MyProfileDA {
  final Database _db = AppDatabase.db;
  final FirebaseUser _user = FirebaseUser();

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
    try {
      await _db.delete(
        UserTable.userTableName,
        where: '${UserTable.userIDColumnName} = ?',
        whereArgs: [_user.getUserID],
      );
      await _user.deleteUser();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }
}
