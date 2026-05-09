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
        'message': 'Login sebagai ${userData['role']} berhasil',
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

      // VALIDASI PASSWORD MINIMAL 6 KARAKTER
      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password harus minimal 6 karakter.'
        };
      }

      // VALIDASI KONFIRMASI PASSWORD
      if (password != confirmPassword) {
        return {
          'success': false,
          'message': 'Password tidak cocok.'
        };
      }

      // REGISTER KE SUPABASE AUTH
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final String? userId = res.user?.id;

      // JIKA AUTH BERHASIL
      if (userId != null) {

        // INSERT DATA KE TABEL PROFILES
        await _supabase.from('profiles').insert({
          'id_profile': userId,
          'username': username,
          'password': password,
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
          'message': 'Akun berhasil dibuat. Silakan login.'
        };
      }

      return {
        'success': false,
        'message': 'Gagal membuat akun autentikasi.'
      };

    } catch (e) {

      final errorMessage = e.toString().toLowerCase();

      // RATE LIMIT
      if (errorMessage.contains('429')) {
        return {
          'success': false,
          'message': 'Terlalu banyak percobaan registrasi. Coba lagi nanti.'
        };
      }

      // EMAIL SUDAH TERDAFTAR
      if (errorMessage.contains('user already registered') ||
          errorMessage.contains('email already registered') ||
          errorMessage.contains('unique_violation')) {

        return {
          'success': false,
          'message': 'Email sudah terdaftar. Silakan login.'
        };
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e'
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
}
