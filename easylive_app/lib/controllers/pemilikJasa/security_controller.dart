import 'package:supabase_flutter/supabase_flutter.dart';

class PemilikJasaSecurityController {
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

  Future<void> changePassword({
    required String current,
    required String newPass,
    required String confirm,
  }) async {
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      throw Exception('Semua field harus diisi');
    }

    if (newPass != confirm) {
      throw Exception('Password baru tidak cocok');
    }

    if (newPass.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    final strength = getPasswordStrength(newPass);
    if (strength < 30) {
      throw Exception('Password terlalu lemah');
    }

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User tidak login');
    }

    final email = user.email ?? '';
    if (email.isEmpty) {
      throw Exception('Email tidak ditemukan');
    }

    // Validasi password saat ini — cek ke tabel profiles dulu
    final profileRes = await supabase
        .from('profiles')
        .select('password')
        .eq('id_profile', user.id)
        .single();

    final storedPassword = profileRes['password'] as String? ?? '';

    if (storedPassword != current) {
      throw Exception('Password saat ini tidak cocok');
    }

    // Update password di Supabase Auth
    await supabase.auth.updateUser(UserAttributes(password: newPass));

    // Update password di tabel profiles
    await supabase
        .from('profiles')
        .update({'password': newPass})
        .eq('id_profile', user.id);
  }
}
