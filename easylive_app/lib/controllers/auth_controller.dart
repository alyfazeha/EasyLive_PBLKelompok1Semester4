import '../models/user_model.dart';

class AuthController {
  static bool login(String email, String password) {
    return true;
  }

  static bool register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
    required String role,
  }) {
    if (password != confirmPassword) return false;

    print("Role: $role"); 

    return true;
  }
}
