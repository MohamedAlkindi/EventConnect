class ExceptionMessages {
  static String emptyFieldMessage = "Please provide info for all fields.";
  // Firebase exception messages.
  static String firebaseWeakPassMessage = "Please provide a stronger password.";

  static String firebaseEmailInUseMessage = "This email is already in use.";

  static String firebaseInvalidEmailMessage = "Please provide a valid email.";

  static String firebaseUnknownException =
      "Please check your internet connection or try again later.";

  // Firebase Register exceptions messages.
  static String passwordsDontMatchMessage = "Please provide the same password.";

  // Firebase login messages.
  // for all sign in errors exception the generic or the no internet conenction.

  static String invalidCredentialsException =
      'Please check your inputs or try to sign up.';

  static String noConnectionException =
      'Please check your internet connection.';

  // Generic exception message.
  static String genericExceptionMessage =
      "An error occurred, please check your inputs or try again later.";

  static String notUniqueUsernameMessage =
      "This username is already being used.";
}
