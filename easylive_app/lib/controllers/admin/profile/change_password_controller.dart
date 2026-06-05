import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeAdminPasswordController {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Ubah password admin.
  /// Implementasi: update password via Supabase Auth yang tersambung.
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) {
      throw Exception('Email wajib diisi');
    }
    if (currentPassword.isEmpty) {
      throw Exception('Password saat ini wajib diisi');
    }
    if (newPassword.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    final auth = _supabase.auth;

    // Validasi password saat ini (supabase auth biasanya akan menolak jika salah)
    await auth.signInWithPassword(
      email: normalizedEmail,
      password: currentPassword,
    );

    // Update password ke password baru.
    await auth.updateUser(UserAttributes(password: newPassword));
  }
}
