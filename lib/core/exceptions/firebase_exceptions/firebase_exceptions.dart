class FirebaseWeakPass implements Exception {
  final String message;
  FirebaseWeakPass({required this.message});

  @override
  toString() => message;
}

class FirebaseEmailInUse implements Exception {
  final String message;
  FirebaseEmailInUse({required this.message});

  @override
  toString() => message;
}

class FirebaseInvalidEmail implements Exception {
  final String message;
  FirebaseInvalidEmail({required this.message});

  @override
  toString() => message;
}

class FirebaseUnknownException implements Exception {
  final String message;
  FirebaseUnknownException({required this.message});

  @override
  toString() => message;
}
