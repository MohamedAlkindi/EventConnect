import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';

class CheckDataDa {
  final db = AppDatabase.db;
  FirebaseUser user = FirebaseUser();

  Future<bool> completedUserData() async {
    final result = await db.rawQuery(
        "SELECT ${UserTable.userLocationColumnName}, ${UserTable.userProfilePicColumnName} FROM ${UserTable.userTableName} WHERE ${UserTable.userIDColumnName} = ?",
        [user.getUserID]);
    return (result.isNotEmpty &&
        result[0][UserTable.userLocationColumnName] != null &&
        result[0][UserTable.userProfilePicColumnName] != null);
  }
}
