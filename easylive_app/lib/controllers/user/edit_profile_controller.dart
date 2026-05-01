class EditProfileController {
  String name = "Alyfa Zahra";
  String email = "alyfa@gmail.com";
  String role = "User";
  String password = "";
  String imagePath = "";

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
      return "Nama tidak boleh kosong";
    }
    if (newEmail.isEmpty) {
      return "Email tidak boleh kosong";
    }
    if (!isValidEmail(newEmail)) {
      return "Format email tidak valid";
    }
    if (newRole.isEmpty) {
      return "Role tidak boleh kosong";
    }
    if (newPassword.isNotEmpty && newPassword.length < 6) {
      return "Password harus minimal 6 karakter";
    }
    return null;
  }

  void updateProfile({
    required String newName,
    required String newEmail,
    required String newRole,
    required String newPassword,
    String? newImagePath,
  }) {
    name = newName;
    email = newEmail;
    role = newRole;
    password = newPassword;
    if (newImagePath != null) {
      imagePath = newImagePath;
    }

    print("Profile updated: name=$name, email=$email, role=$role");
  }

  /// Update image path
  void updateImage(String path) {
    imagePath = path;
    print("Image updated: $path");
  }
}
