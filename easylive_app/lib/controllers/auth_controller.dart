import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  // Shortcut untuk memanggil client Supabase
  static SupabaseClient get _supabase => Supabase.instance.client;

  /// LOGIN: Mengecek email dan password langsung ke tabel 'profiles'
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
        return {
          'success': false,
          'message': 'Email atau password salah.',
        };
      }

      return {
        'success': true,
        'message': 'Login berhasil',
        'role': userData['role'] ?? 'user',
        'userData': userData,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  /// REGISTER: Menyimpan data user baru ke tabel 'profiles'
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
      // Validasi kecocokan password[cite: 2]
      if (password != confirmPassword) {
        return {'success': false, 'message': 'Password tidak cocok.'};
      }

      // Langsung insert ke tabel profiles tanpa menggunakan auth.signUp[cite: 2]
      // Kolom 'id' akan terisi otomatis oleh database (auto-increment)[cite: 2]
      await _supabase.from('profiles').insert({
        'full_name': fullName,
        'username': username,
        'email': email,
        'password': password, // Disimpan sebagai teks biasa sesuai tabelmu[cite: 2]
        'role': role,
        'phone_number': phone,
      });

      return {
        'success': true,
        'message': 'Registrasi berhasil. Silakan login.',
      };
    } catch (e) {
      // Menangani error jika email atau username sudah dipakai[cite: 2]
      if (e.toString().contains('unique_violation')) {
        return {
          'success': false, 
          'message': 'Email atau Username sudah terdaftar.'
        };
      }
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  /// LOGOUT: Karena tidak pakai session Supabase Auth, cukup arahkan ke Login[cite: 2]
  static Future<void> logout() async {
    // Jika nanti kamu pakai Session, tambahkan pembersihan data di sini
    await _supabase.auth.signOut(); 
  }

  /// Ambil role user berdasarkan email[cite: 2]
  static Future<String?> getUserRole(String email) async {
    final userData = await _supabase
        .from('profiles')
        .select('role')
        .eq('email', email)
        .maybeSingle();
    return userData?['role'];
  }
}