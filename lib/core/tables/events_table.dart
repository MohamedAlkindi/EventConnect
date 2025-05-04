class EventsTable {
  static String get eventTableName => 'Event';
  static String get eventIDColumnName => 'EventID';
  static String get eventNameColumnName => 'Name';
  static String get eventCategoryColumnName => 'Category';
  static String get eventPictureColumnName => 'Picture';
  static String get eventLocationColumnName => 'Location';
  static String get eventDateTimeColumnName => 'DateAndTime';
  static String get eventDescriptionColumnName => 'Description';
  static String get eventGenderResrictionColumnName => 'GenderRestriction';

  static String get createEventTable => """
    CREATE TABLE `$eventTableName` (
	    `$eventIDColumnName`	INTEGER NOT NULL,
	    `$eventNameColumnName`	TEXT NOT NULL UNIQUE,
	    `$eventCategoryColumnName`	TEXT NOT NULL,
	    `$eventPictureColumnName`	BLOB NOT NULL,
      `$eventLocationColumnName`	TEXT NOT NULL,
      `$eventDateTimeColumnName`	TEXT NOT NULL,
      `$eventDescriptionColumnName`	TEXT NOT NULL,
      `$eventGenderResrictionColumnName`	TEXT NOT NULL,
      PRIMARY KEY(`$eventIDColumnName`)
    );
  """;
}
