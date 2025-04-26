// Might change name later got no better ones now
import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/tables/user_table.dart';

class InsertUser {
  final db = AppDatabase.db;
  FirebaseUser firebaseUser = FirebaseUser();

  Future<bool> isUnique(String userName) async {
    List<Map<String, dynamic>> userNames =
        await db.query('User', where: "Username = ?", whereArgs: [userName]);

    return userNames.isEmpty;
  }

  Future<void> insertUsername(String userName) async {
    await db.insert('User', {
      UserTable.userIDColumnName: firebaseUser.getUserID,
      UserTable.userNameColumnName: userName,
    });
  }
}
