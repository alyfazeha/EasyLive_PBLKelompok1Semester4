import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  static SupabaseClient get _supabase => Supabase.instance.client;

  /// Login dengan email dan password menggunakan Supabase Auth
  /// Returns Map dengan status dan data user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Login menggunakan Supabase Auth
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return {
          'success': false,
          'message': 'Login gagal. Email atau password salah.',
        };
      }

      // Ambil data user dari tabel 'profiles' berdasarkan email
      final userData = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (userData == null) {
        // Jika data user tidak ada di tabel profiles, logout dan return error
        await _supabase.auth.signOut();
        return {'success': false, 'message': 'Data user tidak ditemukan.'};
      }

      return {
        'success': true,
        'message': 'Login berhasil',
        'user': response.user,
        'role': userData['role'] ?? 'user',
        'userData': userData,
      };
    } on AuthException {
      return {'success': false, 'message': 'Email atau password salah.'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  /// Register user baru
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String username,
    required String phone,
    required String role,
  }) async {
    try {
      if (password != confirmPassword) {
        return {'success': false, 'message': 'Password tidak cocok.'};
      }

      // Register menggunakan Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return {'success': false, 'message': 'Registrasi gagal.'};
      }

      // Insert data user ke tabel 'profiles'
      await _supabase.from('profiles').insert({
        // id: auto increment, tidak perlu diisi manual
        'full_name': fullName,
        'username': username,
        'email': email,
        'role': role,
        'phone_number': phone,
      });

      return {
        'success': true,
        'message': 'Registrasi berhasil. Silakan login.',
        'user': response.user,
      };
    } on AuthException {
      return {'success': false, 'message': 'Registrasi gagal.'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  /// Logout
  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  /// Get current user
  static User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  /// Get user role dari tabel users
  static Future<String?> getUserRole(String email) async {
    final userData = await _supabase
        .from('profiles')
        .select('role')
        .eq('email', email)
        .maybeSingle();
    return userData?['role'];
  }
}
