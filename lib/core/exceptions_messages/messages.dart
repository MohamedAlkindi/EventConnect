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

  static String firebaseInvalidCredentialsException =
      'Please check your inputs or try to sign up.';

  static String firebaseNoConnectionException =
      'Please check your internet connection.';

  // Generic exception message.
  static String genericExceptionMessage =
      "An error occurred, please check your inputs or try again later.";

  static String notUniqueUsernameMessage =
      "This username is already being used.";

  static String shortUsernameMessage =
      "This username is too short, please at least enter 6 characters";

  static String apiError = "Something went wrong restart the app";

  static String categoryError =
      "An error happened while fetching the category events";

  static String addEventError =
      "An error happened while adding an event to your events";
}
