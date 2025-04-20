import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/exceptions_messages/messages.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:sqflite/sqflite.dart';

class CompleteProfileDa {
  // I need to first check if the profile has been finalized before or not,,
  final Database _db = AppDatabase.db;
  FirebaseUser user = FirebaseUser();

// Check how to do dis ting, im out for now...
  Future<void> finalizeProfile(
      {required Map<String, dynamic> updatedData}) async {
    try {
      await _db.update('User', updatedData,
          where: 'UserID = ?', whereArgs: [user.userID]);
    } catch (e) {
      throw Exception(ExceptionMessages.genericExceptionMessage);
    }
  }
}
