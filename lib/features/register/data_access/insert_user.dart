// Might change name later got no better ones now
import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/exceptions/register_exceptions/register_exceptions.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';

class InsertUser {
  final db = AppDatabase.db;
  FirebaseUser firebaseUser = FirebaseUser();

  Future<void> isUnique(String userName) async {
    List<Map<String, dynamic>> userNames =
        await db.query('User', where: "Username = ?", whereArgs: [userName]);

    if (userNames.isEmpty) {
      insertUsername(userName);
    } else {
      throw NotUniqueUsername(
          message: ExceptionMessages.notUniqueUsernameMessage);
    }
  }

  Future<void> insertUsername(String userName) async {
    await db.insert('User', {
      "UserID": firebaseUser.userID,
      "Username": userName,
    });
  }
}
