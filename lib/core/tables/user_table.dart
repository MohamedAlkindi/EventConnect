class UserTable {
  static String get userTableName => 'User';
  static String get userIDColumnName => 'UserID';
  static String get userNameColumnName => 'Username';
  static String get userLocationColumnName => 'Location';
  static String get userProfilePicColumnName => 'ProfilePic';

  static String get createUserTable => """
    CREATE TABLE `$userTableName` (
	    `$userIDColumnName`	TEXT NOT NULL,
	    `$userNameColumnName`	TEXT NOT NULL UNIQUE,
	    `$userLocationColumnName`	TEXT,
	    `$userProfilePicColumnName`	BLOB
    );
  """;
}
