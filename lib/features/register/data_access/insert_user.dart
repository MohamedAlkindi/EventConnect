// Might change name later got no better ones now
import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class InsertUser {
  final db = AppDatabase.db;
  FirebaseUser firebaseUser = FirebaseUser();

  Future<bool> isUnique(String userName) async {
    List<Map<String, dynamic>> userNames =
        await db.query('User', where: "Username = ?", whereArgs: [userName]);

    if (userNames.isEmpty) {
      insertUsername(userName);
      return true;
    } else {
      return false;
    }
  }

  Future<void> insertUsername(String userName) async {
    await db.insert('User', {
      "UserID": firebaseUser.userID,
      "Username": userName,
    });
  }
}
