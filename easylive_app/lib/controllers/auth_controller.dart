import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  static SupabaseClient get _supabase => Supabase.instance.client;

  /// LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Mencari data di tabel profiles yang email dan password-nya cocok
      final userData = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .eq('password', password)
          .maybeSingle();

      if (userData == null) {
        return {'success': false, 'message': 'Email atau password salah.'};
      }

      return {
        'success': true,
        'message': 'Login berhasil',
        'role': userData['role'] ?? 'user',
        'userData': userData,
      };
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
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
      if (password != confirmPassword) {
        return {'success': false, 'message': 'Password tidak cocok.'};
      }

      // 1. Mendaftarkan akun ke Supabase Auth agar mendapatkan UUID
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final String? userId = res.user?.id;

      if (userId != null) {
        // 2. Memasukkan data ke tabel profiles menggunakan id_profile dari Auth
        await _supabase.from('profiles').insert({
          'id_profile': userId, // Menghubungkan ID Auth ke tabel kita
          'full_name': fullName,
          'username': username,
          'email': email,
          'password': password,
          'role': role,
          'phone': phone, // SESUAI: Menggunakan 'phone' bukan 'phone_number'
          'birthdate': birthdate,
          'gender': gender,
          'address': address,
        });

        return {
          'success': true,
          'message': 'Registrasi berhasil. Silakan login.',
        };
      }

      return {'success': false, 'message': 'Gagal membuat akun autentikasi.'};
    } catch (e) {
      if (e.toString().contains('unique_violation')) {
        return {
          'success': false,
          'message': 'Email atau Username sudah terdaftar.',
        };
      }
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
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
}
