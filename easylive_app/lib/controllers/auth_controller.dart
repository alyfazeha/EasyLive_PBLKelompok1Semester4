import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  static SupabaseClient get _supabase => Supabase.instance.client;

  /// LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        return {
          'success': false,
          'message': 'Login failed: user is null',
        };
      }

      // Jangan pakai `.single()` supaya login tidak gagal total kalau row
      // `profiles` belum ada / tidak match.
      final userData = await _supabase
          .from('profiles')
          .select()
          .eq('id_profile', user.id)
          .maybeSingle();

      final role = (userData?['role'] ?? 'user').toString();

      return {
        'success': true,
        'message': userData == null
            ? 'Login successful (profiles row not found)'
            : 'Login as $role successful',
        'role': role,
        'userData': userData ?? <String, dynamic>{},
      };
    } catch (e) {
      return {
        'success': false,
        'message': _formatSupabaseAuthError(e),
      };
    }
  }

  /// REGISTER
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    required String username,
    required String phone,
    required String role,
    required String birthdate,
    required String gender,
    required String address,
  }) async {
    try {
      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password harus minimal 6 karakter.',
        };
      }

      if (password != confirmPassword) {
        return {
          'success': false,
          'message': 'Password tidak cocok.',
        };
      }

      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final String? userId = res.user?.id;

      if (userId != null) {
        await _supabase.from('profiles').insert({
          'id_profile': userId,
          'username': username,
          'full_name': fullName,
          'phone': phone,
          'birth_date': birthdate,
          'gender': gender,
          'email': email,
          'role': role,
          'address': address,
        });

        return {
          'success': true,
          'message': 'Akun berhasil dibuat. Silakan login.',
        };
      }

      return {
        'success': false,
        'message': 'Gagal membuat akun autentikasi.',
      };
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('429')) {
        return {
          'success': false,
          'message': 'Terlalu banyak percobaan registrasi. Coba lagi nanti.',
        };
      }

      if (errorMessage.contains('user already registered') ||
          errorMessage.contains('email already registered') ||
          errorMessage.contains('unique_violation')) {
        return {
          'success': false,
          'message': 'Email sudah terdaftar. Silakan login.',
        };
      }

      return {
        'success': false,
        'message': _formatSupabaseAuthError(e),
      };
    }
  }

  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  static Future<String?> getUserRole(String email) async {
    final userData = await _supabase
        .from('profiles')
        .select('role')
        .eq('email', email)
        .maybeSingle();
    return userData?['role'];
  }

  static String _formatSupabaseAuthError(Object e) {
    if (e is AuthException) {
      return e.message;
    }
    return 'Auth error: $e';
  }
}

