class ExceptionMessages {
  // Instead of returning localized strings, return keys. UI should localize using AppLocalizations.of(context)!.key
  static String emptyFieldMessage = 'emptyFieldMessage';
  // Firebase exception messages.
  static String firebaseWeakPassMessage = 'firebaseWeakPassMessage';

  static String firebaseEmailInUseMessage = 'firebaseEmailInUseMessage';

  static String firebaseInvalidEmailMessage = 'firebaseInvalidEmailMessage';

  static String firebaseUnknownException = 'firebaseUnknownException';

  // Firebase Register exceptions messages.
  static String passwordsDontMatchMessage = 'passwordsDontMatchMessage';

  // Firebase login messages.
  // for all sign in errors exception the generic or the no internet conenction.

  static String firebaseInvalidCredentialsException =
      'firebaseInvalidCredentialsException';

  static String firebaseNoConnectionException = 'firebaseNoConnectionException';

  // Generic exception message.
  static String genericExceptionMessage = 'genericExceptionMessage';

  static String notUniqueUsernameMessage = 'notUniqueUsernameMessage';

  static String shortUsernameMessage = 'shortUsernameMessage';

  static String apiError = 'apiError';

  static String categoryError = 'categoryError';

  static String addEventError = 'addEventError';
}
