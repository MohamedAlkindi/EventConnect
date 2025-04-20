class ErrorCodes {
  // Firebsae register error codes.
  static String weakPassword = 'weak-password';

  static String emailInUse = 'email-already-in-use';

  static String invalidEmail = 'invalid-email';

  // Firebase login error codes.
  String invalidPasswordException = 'wrong-password';

  // for both invalid pass and user not found.
  String invalidCredentialsException = 'invalid-credential';

  String noConnectionException = 'network-request-failed';

  String invalidEmailException = 'invalid-email';

  String userNotFoundException = 'user-not-found';
}
