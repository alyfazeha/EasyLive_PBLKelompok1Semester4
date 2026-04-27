class SecurityController {
  String currentPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  bool changePassword({
    required String current,
    required String newPass,
    required String confirm,
  }) {
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      return false;
    }
    if (newPass != confirm) {
      return false;
    }
    if (newPass.length < 6) {
      return false;
    }
    // Simulate successful password change
    print("Password changed successfully");
    return true;
  }
}
