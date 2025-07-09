class EmptyFieldException implements Exception {
  final String message;

  EmptyFieldException({required this.message});

  @override
  toString() => message;
}

class GenericException implements Exception {
  final String message;

  GenericException(this.message);

  @override
  toString() => message;
}

class PasswordsDontMatchException implements Exception {
  final String message;

  PasswordsDontMatchException({required this.message});

  @override
  toString() => message;
}

class NotUniqueUsername implements Exception {
  final String message;

  NotUniqueUsername({required this.message});

  @override
  toString() => message;
}

class ShortUsername implements Exception {
  final String message;

  ShortUsername({required this.message});

  @override
  toString() => message;
}
