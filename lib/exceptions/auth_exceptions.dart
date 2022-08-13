class AuthExceptions implements Exception {
  String message;

  AuthExceptions._({required this.message});

  static wrongCredentials() => AuthExceptions._(message: 'Wrong credentials');

  static existedUser() => AuthExceptions._(message: 'The user email/username already exists');

  static unauthenticated() => AuthExceptions._(message: 'No authenticated user');
}
