import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/core/tables/user_table.dart';

class UserEvents {
  static String get userEventsTableName => 'UserEvents';
  static String get userEventsIDColumnName => 'ID';
  static String get userIDColumnName => 'UserID';
  static String get eventIDColumnName => 'EventID';

  static String get createUserEventTable => """
    CREATE TABLE `$userEventsTableName` (
	    `$userEventsIDColumnName`	INTEGER NOT NULL,
	    `$userIDColumnName`	TEXT NOT NULL,
	    `$eventIDColumnName`	INTEGER NOT NULL,
      PRIMARY KEY(`$userEventsIDColumnName`),
      FOREIGN KEY(`$userIDColumnName`) REFERENCES ${UserTable.userTableName}(`$userIDColumnName`),
      FOREIGN KEY(`$eventIDColumnName`) REFERENCES ${EventsTable.eventTableName}(`$eventIDColumnName`)
    );
  """;
}
