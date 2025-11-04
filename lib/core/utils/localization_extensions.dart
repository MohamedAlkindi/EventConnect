import 'package:event_connect/l10n/app_localizations.dart';

extension AppLocalizationsErrorHelper on AppLocalizations {
  String tryTranslate(String key) {
    switch (key) {
      case 'emptyFieldMessage':
        return emptyFieldMessage;
      case 'firebaseWeakPassMessage':
        return firebaseWeakPassMessage;
      case 'firebaseEmailInUseMessage':
        return firebaseEmailInUseMessage;
      case 'firebaseInvalidEmailMessage':
        return firebaseInvalidEmailMessage;
      case 'firebaseUnknownException':
        return firebaseUnknownException;
      case 'passwordsDontMatchMessage':
        return passwordsDontMatchMessage;
      case 'firebaseInvalidCredentialsException':
        return firebaseInvalidCredentialsException;
      case 'firebaseNoConnectionException':
        return firebaseNoConnectionException;
      case 'genericExceptionMessage':
        return genericExceptionMessage;
      case 'notUniqueUsernameMessage':
        return notUniqueUsernameMessage;
      case 'shortUsernameMessage':
        return shortUsernameMessage;
      case 'apiError':
        return apiError;
      case 'categoryError':
        return categoryError;
      case 'addEventError':
        return addEventError;
      default:
        return key;
    }
  }
}
