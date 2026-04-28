class EditProfileController {
  String name = "Alyfa Zahra";
  String email = "alyfa@gmail.com";
  String role = "User";
  String password = "";

  void updateProfile({
    required String newName,
    required String newEmail,
    required String newRole,
    required String newPassword,
  }) {
    name = newName;
    email = newEmail;
    role = newRole;
    password = newPassword;

    print("Profile updated");
  }
}
