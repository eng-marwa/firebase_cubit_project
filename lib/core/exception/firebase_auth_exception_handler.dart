import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExceptionHandler {
  FirebaseAuthExceptionHandler._();

  static String handleException(Exception e) {
    if (e is FirebaseAuthException) {
      return _mapFirebaseAuthError(e);
    } else {
      return e.toString();
    }
  }

  static String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}
