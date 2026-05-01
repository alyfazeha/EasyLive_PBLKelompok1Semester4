class SecurityController {
  String currentPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  /// Hitung kekuatan password (0-100)
  int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Panjang minimal 6 karakter
    if (password.length >= 6) strength += 20;
    if (password.length >= 8) strength += 10;
    if (password.length >= 12) strength += 10;

    // contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength += 15;

    // contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength += 15;

    // contains number
    if (password.contains(RegExp(r'[0-9]'))) strength += 15;

    // contains special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 15;

    return strength.clamp(0, 100);
  }

  /// Dapatkan level kekuatan
  String getStrengthLabel(String password) {
    final strength = getPasswordStrength(password);
    if (strength == 0) return "Tidak ada";
    if (strength <= 30) return "Lemah";
    if (strength <= 60) return "Sedang";
    if (strength <= 80) return "Kuat";
    return "Sangat Kuat";
  }

  /// Dapatkan warna berdasarkan kekuatan
  String getStrengthColor(String password) {
    final strength = getPasswordStrength(password);
    if (strength <= 30) return "red";
    if (strength <= 60) return "orange";
    if (strength <= 80) return "yellow";
    return "green";
  }

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

    // Validasi password minimal
    final strength = getPasswordStrength(newPass);
    if (strength < 30) {
      return false;
    }

    // Simulate successful password change
    print("Password changed successfully");
    return true;
  }

  /// Validasi password baru
  String? validateNewPassword(String password) {
    if (password.isEmpty) {
      return null; // Password opsional
    }
    if (password.length < 6) {
      return "Minimal 6 karakter";
    }
    if (getPasswordStrength(password) < 30) {
      return "Password terlalu lemah";
    }
    return null;
  }
}
