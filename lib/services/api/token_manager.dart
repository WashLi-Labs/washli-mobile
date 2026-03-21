import 'package:firebase_auth/firebase_auth.dart';
import 'api_exception.dart';

class TokenManager {
  static Future<String> getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const UnauthenticatedException('User is not logged in');
    }
    final token = await user.getIdToken(false);
    if (token == null) {
      throw const UnauthenticatedException('Failed to get auth token');
    }
    return token;
  }

  static Future<String> refreshToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const UnauthenticatedException('User is not logged in');
    }
    final token = await user.getIdToken(true);
    if (token == null) {
      throw const UnauthenticatedException('Failed to refresh auth token');
    }
    return token;
  }
}
