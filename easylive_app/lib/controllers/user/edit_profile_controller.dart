import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController {
  String name = "Alyfa Zahra";
  String email = "alyfa@gmail.com";
  String role = "User";
  String password = "";
  String imagePath = "";

  // Extra fields (disamakan dengan Register)
  String phone = "";
  String birthdate = ""; // yyyy-MM-dd
  String gender = "";
  String address = "";

  final _supabase = Supabase.instance.client;

  /// Validasi email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validasi form - returns error message or null if valid
  String? validate({
    required String newName,
    required String newEmail,
    required String newRole,
    required String newPassword,
  }) {
    if (newName.isEmpty) {
      return "Name cannot be empty";
    }
    if (newEmail.isEmpty) {
      return "Email cannot be empty";
    }
    if (!isValidEmail(newEmail)) {
      return "Invalid email format";
    }
    if (newRole.isEmpty) {
      return "Role cannot be empty";
    }
    if (newPassword.isNotEmpty && newPassword.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  Future<void> updateProfile({
    required String newName,
    required String newEmail,
    required String newRole,
    required String newPassword,
    String? newImagePath,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // Update data di tabel profiles Supabase
    await _supabase.from('profiles').update({
      'full_name': newName,
      'email': newEmail,
      'role': newRole,
      'phone': phone,
      'birth_date': birthdate,
      'gender': gender,
      'address': address,
    }).eq('id_profile', user.id);

    // 2. Update Auth (Email & Password jika ada perubahan)
    if (newPassword.isNotEmpty) {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword, email: newEmail),
      );
    }

    // Update local state
    name = newName;
    email = newEmail;
    role = newRole;
    password = newPassword;
    if (newImagePath != null) imagePath = newImagePath;

    print("Profile updated: name=$name, email=$email, role=$role");
  }

  /// Update image path
  void updateImage(String path) {
    imagePath = path;
    print("Image updated: $path");
  }
}
