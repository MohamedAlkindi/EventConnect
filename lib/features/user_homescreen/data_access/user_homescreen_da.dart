import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class UserHomescreenDa {
  final Database _db = AppDatabase.db;
  final FirebaseUser user = FirebaseUser();

  Future<List<Map<String, dynamic>>> getUserProfilePic() async {
    final List<Map<String, dynamic>> result = await _db.query(
      UserTable.userTableName,
      columns: [UserTable.userProfilePicColumnName],
      where: "${UserTable.userIDColumnName} = ?",
      whereArgs: [user.getUserID],
    );

    return result;
  }
}
