import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PemilikKosProfileController extends ChangeNotifier {
  String userName = '';
  String userEmail = '';
  String userImage = '';
  String role = '';
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  PemilikKosProfileController() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final res = await supabase
          .from('profiles')
          .select('username, email, photo, role') // ← photo bukan image_path
          .eq('id_profile', user.id)
          .single();

      userName = res['username'] ?? 'Pemilik Kos';
      userEmail = res['email'] ?? '-';
      userImage = res['photo'] ?? ''; // ← photo bukan image_path
      role = res['role'] ?? '';
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    userName = '';
    userEmail = '';
    userImage = '';
    role = '';
    notifyListeners();
  }

  Future<String?> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      return 'Semua field harus diisi';
    }

    if (newPassword != confirmPassword) {
      return 'Password baru tidak cocok';
    }

    if (newPassword.length < 6) {
      return 'Password minimal 6 karakter';
    }

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return 'User tidak login';

      await supabase.auth.signInWithPassword(
        email: userEmail,
        password: currentPassword,
      );

      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return null;
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return 'Password saat ini salah';
      }
      return 'Gagal update password: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }
}